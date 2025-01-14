import requests
import settings as s


def get_refresh_token(app_key, app_secret, access_code):
    """Get the Dropbox refresh token using the access code."""
    token_url = "https://api.dropbox.com/oauth2/token"

    # Prepare the request data
    data = {
        "code": access_code,
        "grant_type": "authorization_code",
    }

    # Send the POST request to get the refresh token
    response = requests.post(token_url, data=data, auth=(s.dropbox_app_key, s.dropbox_app_secret))

    # Check the response
    if response.status_code == 200:
        response_data = response.json()
        refresh_token = response_data.get("refresh_token")
        access_token = response_data.get("access_token")

        print("Access Token:", access_token)
        print("Refresh Token:", refresh_token)
        return refresh_token
    else:
        print("Error:", response.status_code, response.text)
        raise Exception("Failed to retrieve refresh token")


if __name__ == "__main__":
    # Get the refresh token
    refresh_token = get_refresh_token(s.dropbox_app_key, s.dropbox_app_secret, s.dropbox_access_code)