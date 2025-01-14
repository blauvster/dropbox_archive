
## dropbox-archive
This is a script uses the python modules dropbox and py7zr to create encrypted archives and store them on Dropbox.

The script currently keeps:
 - 7 files less than a week old.
 - 1 file per month for files older than a week.
 - 1 file per year for files older than a year.

### Installation
Install Python 3 and pip on your system.  
There are scripts in the *windows_scripts* and *linux_scripts* directory to setup a virtual environment and schedule the script with tasksheduler or cron.

### Usage
Download this repository.
Login and create an app on Dropbox to use with this script. https://www.dropbox.com/developers/apps
Copy *settings.py.example* as *settings.py*.
Update *settings.py* to suit your needs. Replace all **REPLACE ME** instances.
Then call main.py
```bash
python3 main.py
```
On Windows in a virtual environment:
```cmd
windows_scripts\run.bat
```
On Linux in a virtual environment:
```cmd
linux_scripts\run.sh
```
