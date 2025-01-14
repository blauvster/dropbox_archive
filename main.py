import os
import py7zr
import dropbox
from datetime import datetime, timedelta


def compress_to_7z(source_paths, archive_path, password):
    """Compress to an encrypted 7z file."""
    with py7zr.SevenZipFile(archive_path, 'w', password=password) as archive:
        for path in source_paths:
            if os.path.exists(path):
                if os.path.isdir(path):
                    archive.writeall(path, path if ":" not in path else path.split(":")[1])
                elif os.path.isfile(path):
                    archive.write(path,  path if ":" not in path else path.split(":")[1])
                else:
                    print(f'Error: {path} is not a directory or file.')
            else:
                print(f'Error: {path} does not exist.')


def upload_to_dropbox(file_path, dropbox_client, dropbox_folder):
    """Upload a file to Dropbox."""
    with open(file_path, "rb") as f:
        dropbox_path = f"{dropbox_folder}/{os.path.basename(file_path)}"
        dropbox_client.files_upload(f.read(), dropbox_path, mode=dropbox.files.WriteMode.overwrite)


def list_dropbox_files(dropbox_client, dropbox_folder):
    """List files in the Dropbox folder."""
    files = dropbox_client.files_list_folder(dropbox_folder).entries
    return [f for f in files if isinstance(f, dropbox.files.FileMetadata)]


def manage_backups(dropbox_client, dropbox_folder):
    """Apply retention policies to Dropbox backups."""
    files = list_dropbox_files(dropbox_client, dropbox_folder)
    backups = sorted(files, key=lambda x: x.client_modified, reverse=True)

    daily_cutoff = datetime.now() - timedelta(days=7)
    monthly_cutoff = datetime.now() - timedelta(days=365)

    keep = set()
    for backup in backups:
        modified = backup.client_modified

        if modified >= daily_cutoff:
            keep.add(backup.id)
        elif modified >= monthly_cutoff:
            month_key = modified.strftime("%Y-%m")
            if month_key not in {f.client_modified.strftime("%Y-%m") for f in keep}:
                keep.add(backup.id)
        else:
            year_key = modified.strftime("%Y")
            if year_key not in {f.client_modified.strftime("%Y") for f in keep}:
                keep.add(backup.id)


def main():
    # Use the variables from the settings file
    import settings as s

    # Filename
    archive_path = os.path.join(s.temp_path, s.archive_name)

    # Create backup archive
    compress_to_7z(s.source_paths, archive_path, s.password)

    # Upload to Dropbox
    dropbox_client = dropbox.Dropbox(
        oauth2_refresh_token=s.dropbox_refresh_token,
        app_key=s.dropbox_app_key,
        app_secret=s.dropbox_app_secret
    )
    upload_to_dropbox(archive_path, dropbox_client, s.dropbox_folder)

    # Remove files
    os.remove(archive_path)

    # Manage Dropbox backups
    manage_backups(dropbox_client, s.dropbox_folder)


if __name__ == "__main__":
    main()
