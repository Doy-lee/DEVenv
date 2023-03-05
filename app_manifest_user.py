def get_manifest(is_windows):
    result = []

    # --------------------------------------------------------------------------

    if is_windows:
        version = "7.9.0"
        result.append({
            "label": "digiKam",
            "manifests": [
                {
                    "download_url": f"https://download.kde.org/stable/digikam/{version}/digiKam-{version}-Win64.tar.xz",
                    "download_checksum": "810476996461dc9275e97f1aa0438c77d0fe49f6ae5f6ae36fca983022dafe71",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "digikam.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "aebabac51581c4a0a8fd6950c728d5b8a2306b7251e5f9b1987a437f3576d2c8",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    if is_windows:
        version = "0.25.0"
        result.append({
            "label": "PicoTorrent",
            "manifests": [
                {
                    "download_url": f"https://github.com/picotorrent/picotorrent/releases/download/v{version}/PicoTorrent-{version}-x64.zip",
                    "download_checksum": "375c2445db76b7d51b7cd351b1c5b40f895fb15b502da6073e19aaf6cb08cd76",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "picotorrent.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "135adefb184d6a28d75b18fefebcd23e62005246664ff12f8af5687823630829",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    return result
