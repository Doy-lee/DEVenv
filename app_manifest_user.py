def get_manifest(is_windows):
    result = []

    # --------------------------------------------------------------------------

    if is_windows:
        version = "1.4.1.1024"
        result.append({
            "label": "Everything",
            "manifests": [
                {
                    "download_url": f"https://www.voidtools.com/Everything-{version}.x64.zip",
                    "download_checksum": "4be0851752e195c9c7f707b1e0905cd01caf6208f4e2bfa2a66e43c0837be8f5",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "Everything.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "35cefe4bc4a98ad73dda4444c700aac9f749efde8f9de6a643a57a5b605bd4e7",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    if is_windows:
        version = "22.3"
        result.append({
            "label": "MobaXTerm",
            "manifests": [
                {
                    "download_url": f"https://download.mobatek.net/2232022120824733/MobaXterm_Portable_v{version}.zip",
                    "download_checksum": "c8de508d6731f31a73f061e58942691466d1d24cfa941e642e16e0930be2fad9",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": f"MobaXterm_Personal_{version}.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "e47cb54645a368411c5d6b6cbfa7e25980a2a674d7d0c082f5137b6e77a2f362",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    if is_windows:
        version = "3.0.7039"
        result.append({
            "label": "SystemInformer",
            "manifests": [
                {
                    "download_url": f"https://github.com/winsiderss/si-builds/releases/download/{version}/systeminformer-{version}-bin.zip",
                    "download_checksum": "4557e58f698048e882515faac89c9c7f654247dbf4bd656ceed5c3f97afef77d",
                    "version": "3.0.5847",
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "amd64/SystemInformer.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "8a6e9dfd145e5cb8d03ec3db1b7b0163325be33e5c8fdd4126e9f8df2af2a39c",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    version           = "2.0.0"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""

    if is_windows:
        download_url      = f"https://github.com/ahrm/sioyek/releases/download/v{version}/sioyek-release-windows-portable.zip"
        download_checksum = "1f4fedbb38c0dc46bbba4bb95d0d6fab39fcf3525092ac26d92c891684d2bf8d"
        checksum          = "6c660f0f7265fabe6d943d15d9b5c7e85f2dbcf7fecb7d2cd0639e7086b1c034"
        exe_path          = "sioyek.exe"
    else:
        download_url      = f"https://github.com/ahrm/sioyek/releases/download/v{version}/sioyek-release-linux-portable.zip"
        download_checksum = "3f90659c1f29705de680b3607ae247582eab8860015c208d364a0f3fc15d3222"
        checksum          = "7abc12e8fe71b0285e067866bcea2ea0e025e37291f6bce450675a567172e44f"
        exe_path          = "Sioyek-x86_64.AppImage"

    result.append({
        "label": "Sioyek",
        "manifests": [
            {
                "download_url": download_url,
                "download_checksum": download_checksum,
                "version": version,
                "unzip_method": 'default',
                "executables": [
                    {
                        "path": exe_path,
                        "symlink": [],
                        "add_to_devenv_path": False,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    if is_windows:
        version = "4_15"
        result.append({
            "label": "WizTree",
            "manifests": [
                {
                    "download_url": f"https://www.diskanalyzer.com/files/wiztree_{version}_portable.zip",
                    "download_checksum": "dfa135cf5f87317ebe6112b7c8453f9eed5d93b78e9040a0ec882cbd6b200a95",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "WizTree64.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "141d7b51dbef71205f808e87b5e2d85a75eac69d060f678db628be2a0984a929",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    if is_windows:
        version = "1.64.0"
        result.append({
            "label": "RClone",
            "manifests": [
                {
                    "download_url": f"https://github.com/rclone/rclone/releases/download/v{version}/rclone-v{version}-windows-amd64.zip",
                    "download_checksum": "b1251cfdcbc44356e001057524c3e2f7be56d94546273d10143bfa1148c155ab",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "rclone.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "64e0322e3bec6fb9fa730b7a14106e1e59fa186096f9a8d433a5324eb6853e01",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    if is_windows:
        version = "1.5.3"
        result.append({
            "label": "Eyes-Thanks",
            "manifests": [
                {
                    "download_url": f"https://github.com/yalov/eyes-thanks/releases/download/{version}/EyesThanks_v{version}.zip",
                    "download_checksum": "6ab2b20730f56aa54263eb942be8849f52f9cba26438aee3c1b01103069411cc",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "Eyes' Thanks.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "48d232bd4a302b11378791eee844b42a2e30fe3553acf17a3b9e8ee0fcf27766",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    if is_windows:
        version = "15.0.0"
        result.append({
            "label": "ShareX",
            "manifests": [
                {
                    "download_url": f"https://github.com/ShareX/ShareX/releases/download/v{version}/ShareX-{version}-portable.zip",
                    "download_checksum": "c3bc97e9fb8d107e92cb494b50f842fccafbc9fd810588a1b635aee4dbe90bc1",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "ShareX.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "0b679c46c2940edc09cff8ae0b0f4578aeda0346b9c402276b166aee4ec864be",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    version           = "0.12"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""

    if is_windows:
        download_url      = f"https://bitbucket.org/heldercorreia/speedcrunch/downloads/SpeedCrunch-{version}-win32.zip"
        download_checksum = "024362bccd7908b508192cd90c2f6a716b5aa4fa5c7ff2aea9a1bf49d6580175"
        checksum          = "c80409586d6b36d315ce9462fd9020a12b07633a569d94a8ee057bcd18ee5647"
        exe_path          = "speedcrunch.exe"
    else:
        download_url      = f"https://bitbucket.org/heldercorreia/speedcrunch/downloads/SpeedCrunch-{version}-linux64.tar.bz2"
        download_checksum = "9347bef2068053ad15c5914ee147bf11a1ccb1d30cb18d63d0178380c327e8fc"
        checksum          = "06c7e7f68027f133dc7874f663873244b695c8a7d2aec9cde0e40b7a5b9a4db1"
        exe_path          = "speedcrunch"

    result.append({
        "label": "SpeedCrunch",
        "manifests": [
            {
                "download_url": download_url,
                "download_checksum": download_checksum,
                "version": version,
                "unzip_method": 'default',
                "executables": [
                    {
                        "path": exe_path,
                        "symlink": [],
                        "add_to_devenv_path": False,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version           = "2.7.6"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""

    if is_windows:
        download_url      = f"https://github.com/keepassxreboot/keepassxc/releases/download/{version}/KeePassXC-{version}-Win64.zip"
        download_checksum = "42aed8fee2b5fbc7ecae4494c274aece35f3de57c4370c1cd0eb365e501fb4c6"
        checksum          = "915f6879ca20fc7ffd196402e301676c3bd04419ee90486cbd56662dbb7d0b77"
        exe_path          = "KeePassXC.exe"
    else:
        exe_path          = f"KeePassXC-{version}-x86_64.AppImage"
        download_url      = f"https://github.com/keepassxreboot/keepassxc/releases/download/{version}/{exe_path}"
        download_checksum = "f32f7e7ab4bca789b24bd6a420c1d87dff40982646abef58fca481a7c56ace48"
        checksum          = download_checksum

    result.append({
        "label": "KeePassXC",
        "manifests": [
            {
                "download_url": download_url,
                "download_checksum": download_checksum,
                "version": version,
                "unzip_method": 'default',
                "executables": [
                    {
                        "path": exe_path,
                        "symlink": [],
                        "add_to_devenv_path": False,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "3.56.0"
    symlink = []

    if is_windows:
        exe_path          = "LosslessCut.exe"
        download_url      = f"https://github.com/mifi/lossless-cut/releases/download/v{version}/LosslessCut-win-x64.7z"
        download_checksum = "4dbbad634a09d16fd2cb53461ca8b7b5e8506fdaf03f811233646493b3fe04c0"
        checksum          = "14452473962369dd3443976dab7dc15a6fbbb60a6c758e8b95337ed161648a5a"
    else:
        exe_path          = f"LosslessCut-linux-x86_64.AppImage"
        download_url      = f"https://github.com/mifi/lossless-cut/releases/download/v{version}/{exe_path}"
        download_checksum = ""
        checksum          = download_checksum

    result.append({
        "label": "LosslessCut",
        "manifests": [
            {
                "download_url": download_url,
                "download_checksum": download_checksum,
                "version": version,
                "unzip_method": 'default',
                "executables": [
                    {
                        "path": exe_path,
                        "symlink": symlink,
                        "add_to_devenv_path": False,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    return result
