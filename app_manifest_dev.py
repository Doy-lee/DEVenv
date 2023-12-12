def get_manifest(is_windows):
    result = []

    # --------------------------------------------------------------------------

    version           = "20221119-145034-49b9839f"
    download_url      = ""
    exe_name          = ""
    download_checksum = ""
    checksum          = ""
    symlink           = []

    if is_windows:
        exe_path          = f"wezterm-gui.exe"
        download_url      = f"https://github.com/wez/wezterm/releases/download/{version}/WezTerm-windows-{version}.zip"
        download_checksum = "7041d2c02d226c0c051cc9f6373d51ac9a2de00025e18582077c76e8ad68abe1"
        checksum          = "e3faa247d69a8a966302a2ab4e655b08b79548707db79a7b724cf18cccf5ae35"
    else:
        exe_path          = f"WezTerm-{version}-Ubuntu18.04.AppImage"
        download_url      = f"https://github.com/wez/wezterm/releases/download/{version}/{exe_path}"
        download_checksum = "1611b4d5ba2598587874b3ff51dc0849e7ece7f2e0a0d376e13fbd00f9ae2807"
        checksum          = download_checksum

    result.append({
        "label": "WezTerm",
        "manifests": [
            {
                "version": version,
                "download_checksum": download_checksum,
                "download_url": download_url,
                "unzip_method": 'default',
                "executables": [
                    {
                        "path": exe_path,
                        "symlink": symlink,
                        "add_to_devenv_path": True,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "2.304"
    result.append({
        "label": "JetBrains_Mono_Font",
        "manifests": [
            {
                "download_checksum": "6f6376c6ed2960ea8a963cd7387ec9d76e3f629125bc33d1fdcd7eb7012f7bbf",
                "version": "2.304",
                "download_url": f"https://download.jetbrains.com/fonts/JetBrainsMono-{version}.zip",
                "unzip_method": 'default',
                "executables": [
                    {
                        "path": "fonts/ttf/JetBrainsMono-Regular.ttf",
                        "symlink": [],
                        "add_to_devenv_path": False,
                        "checksum": "a0bf60ef0f83c5ed4d7a75d45838548b1f6873372dfac88f71804491898d138f",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    result.append({
        "label": "CMake",
        "manifests": [],
    })

    download_url      = ""
    exe_path          = ""
    download_checksum = ""
    checksum          = ""
    symlink           = []

    version = "3.26.4"
    if is_windows:
        exe_path          = f"bin/cmake.exe"
        download_url      = f"https://github.com/Kitware/CMake/releases/download/v{version}/cmake-{version}-windows-x86_64.zip"
        download_checksum = "62c35427104a4f8205226f72708d71334bd36a72cf72c60d0e3a766d71dcc78a"
        checksum          = "c582c73e5c3d9c7f619a1df47bf5eddfd37cef831a4558707f01eb2b455a997a"
        symlink           = [f"cmake-{version}.exe"]
    else:
        exe_path          = f"bin/cmake"
        download_url      = f"https://github.com/Kitware/CMake/releases/download/v{version}/cmake-{version}-linux-x86_64.tar.gz"
        download_checksum = "ba1e0dcc710e2f92be6263f9617510b3660fa9dc409ad2fb8190299563f952a0"
        checksum          = "f9145454fdcbf2bb6518db2f93a1594fd778500b8c31cba9ecc66e4547e11f51"
        symlink           = [f"cmake-{version}"]

    result[-1]['manifests'].append({
        "download_checksum": download_checksum,
        "download_url": download_url,
        "version": version,
        "executables": [
            {
                "path": exe_path,
                "symlink": symlink,
                "add_to_devenv_path": True,
                "checksum": checksum,
            }
        ],
        "add_to_devenv_script": [],
    })

    version = "3.24.3"
    if is_windows:
        exe_path          = f"bin/cmake.exe"
        download_url      = f"https://github.com/Kitware/CMake/releases/download/v{version}/cmake-{version}-windows-x86_64.zip"
        download_checksum = "86c605507e4175d1e1cd2fd9098d6a5b6bf6ff7f885f4b75ddfc9ac3dc1d4452"
        checksum          = "f96ba3c14b0a73fe1ddd8e9a14f084d1ab23a507bb30c3480b2c2f47aef58cbe"
        symlink           = [f"cmake-{version}.exe"]
    else:
        exe_path          = f"bin/cmake"
        download_url      = f"https://github.com/Kitware/CMake/releases/download/v{version}/cmake-{version}-linux-x86_64.tar.gz"
        download_checksum = "8e3d048c7fb26767b00db6a55025aa380d91f45d8f3749e9b9961ef25744b102"
        checksum          = "4c310327482e09db8bfafd64b50cfa898a986f9fa757b82e21dcbafb2d9accce"
        symlink           = [f"cmake-{version}"]

    result[-1]['manifests'].append({
        "download_checksum": download_checksum,
        "download_url": download_url,
        "version": version,
        "executables": [
            {
                "path": exe_path,
                "symlink": symlink,
                "add_to_devenv_path": False,
                "checksum": checksum,
            }
        ],
        "add_to_devenv_script": [],
    })

    version = "3.23.4"
    if is_windows:
        exe_path          = f"bin/cmake.exe"
        download_url      = f"https://github.com/Kitware/CMake/releases/download/v{version}/cmake-{version}-windows-x86_64.zip"
        download_checksum = "df15113aaab9e5f8cac254e02cf23f70d02407c9bf2983c82a9fe0d35bd20682"
        checksum          = "426074cd812586551fbab2bde67377113e2085c78c2e9a887748e85b4dc3dda5"
        symlink           = [f"cmake-{version}.exe"]
    else:
        exe_path          = f"bin/cmake"
        download_url      = f"https://github.com/Kitware/CMake/releases/download/v{version}/cmake-{version}-linux-x86_64.tar.gz"
        download_checksum = "3fbcbff85043d63a8a83c8bdf8bd5b1b2fd5768f922de7dc4443de7805a2670d"
        checksum          = "0f2d7256be13a5955af1462d6dd40e1f0c0ce9fa822953f31ae27aa78da73440"
        symlink           = [f"cmake-{version}"]

    result[-1]['manifests'].append({
        "download_checksum": download_checksum,
        "download_url": download_url,
        "version": version,
        "executables": [
            {
                "path": exe_path,
                "symlink": symlink,
                "add_to_devenv_path": False,
                "checksum": checksum,
            }
        ],
        "add_to_devenv_script": [],
    })

    version = "3.10.3"
    if is_windows:
        download_url      = f"https://github.com/Kitware/CMake/releases/download/v{version}/cmake-{version}-win64-x64.zip"
        download_checksum = "3bd57d1cfcf720a4cc72db77bda4c76a7b700fb0341821ad868963ad28856cd0"
        checksum          = "f2e3b486d87d2a6bc19b3a62c740028f3f8945875196ac7d3d0e69649e98730a"
        symlink           = [f"cmake-{version}.exe"]
    else:
        download_url      = f"https://github.com/Kitware/CMake/releases/download/v{version}/cmake-{version}-Linux-x86_64.tar.gz"
        download_checksum = "9e7c48b797484f74c5ee3ae55132b40b16ed8e81ee762402da8971205b0a896b"
        checksum          = "f12fbb91b198738cd0ade85ab1aa3f65964579a850042de3d2385cc0d593ad46"
        symlink           = [f"cmake-{version}"]

    result[-1]['manifests'].append({
        "download_checksum": download_checksum,
        "download_url": download_url,
        "version": version,
        "unzip_method": 'default',
        "executables": [
            {
                "path": exe_path,
                "symlink": symlink,
                "add_to_devenv_path": False,
                "checksum": checksum
            }
        ],
        "add_to_devenv_script": [],
    })

    # --------------------------------------------------------------------------

    version           = "1.9.7"
    download_url      = ""
    exe_path          = ""
    download_checksum = ""
    checksum          = ""
    symlink           = []

    if is_windows:
        exe_path          = f"doxygen.exe"
        download_url      = f"https://github.com/doxygen/doxygen/releases/download/Release_{version.replace('.', '_')}/doxygen-{version}.windows.x64.bin.zip"
        download_checksum = "d0c0c4c2b707582d57a9ed51253a638069c91427b0e569dedd963fdd01bf1136"
        checksum          = "b6d7dd978386919f6303e8cac271fc5648c4aa3def5023fc6dc49df58274eb7e"
        symlink           = [f"doxygen-{version}.exe"]
    else:
        exe_path          = f"bin/doxygen"
        download_url      = f"https://github.com/doxygen/doxygen/releases/download/Release_{version.replace('.', '_')}/doxygen-{version}.linux.bin.tar.gz"
        download_checksum = "8bcb7cbdb9d8ae78d0bf65a383bc533db5232e2527ab10743f1e58cba92a7d43"
        checksum          = "230cc485bff7535c1a39addcc8c9893615092cfbb46a4a134510d41deb53807c"
        symlink           = [f"doxygen-{version}"]

    result.append({
        "label": "Doxygen",
        "manifests": [
            {
                "download_checksum": download_checksum,
                "download_url": download_url,
                "version": version,
                "unzip_method": 'default',
                "executables": [
                    {
                        "path": exe_path,
                        "symlink": symlink,
                        "add_to_devenv_path": True,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    if is_windows:
        label   = "Git"
        version = "2.39.1"
        result.append({
            "label": f"{label}",
            "manifests": [
                {
                    "download_checksum": "b898306a44084b5fa13b9a52e06408d97234389d07ae41d9409bdf58cad3d227",
                    "download_url": f"https://github.com/git-for-windows/git/releases/download/v{version}.windows.1/PortableGit-{version}-64-bit.7z.exe",
                    "version": version,
                    "unzip_method": '7zip',
                    "executables": [
                        {
                            "path": "cmd/git.exe",
                            "symlink": [],
                            "add_to_devenv_path": True,
                            "checksum": "2fc6d5be237efb6b429d8f40975f1a1cfe3bcac863d9335e24096c8b0ec38105",
                        }
                    ],
                    "add_to_devenv_script": [
                        f"set PATH=%~dp0{label}\\{version}\\mingw64\\bin;%PATH%",
                        f"set PATH=%~dp0{label}\\{version}\\usr\\bin;%PATH%",
                    ],
                }
            ],
        })

    # --------------------------------------------------------------------------

    if is_windows:
        result.append({
            "label": "GCC_MinGW_AArch64",
            "manifests": [],
        })

        arch = "aarch64-none-elf"
        version = "12.2.0"

        result[-1]['manifests'].append({
            "download_checksum": "729e8af6aecd85cce63435b94c310c01983091b5db54842cd6604298f29d047f",
            "download_url": f"https://github.com/mmozeiko/build-gcc-arm/releases/download/gcc-v{version}/gcc-v{version}-{arch}.7z",
            "version": version,
            "unzip_method": 'default',
            "executables": [
                {
                    "path": f"bin/{arch}-g++.exe",
                    "checksum": "a26baffa86bc3401790d682f13f9b321ea56153eae7dd4f332bde40a6b76fcb3",
                    "symlink": [f"{arch}-g++-{version}.exe"],
                    "add_to_devenv_path": True,
                },
                {
                    "path": f"bin/{arch}-gcc.exe",
                    "checksum": "0f594c7e741207f1613aa958369b12fab781741718688710b7082cac172fadf5",
                    "symlink": [f"{arch}-gcc-{version}.exe"],
                    "add_to_devenv_path": True,
                },
            ],
            "add_to_devenv_script": [],
        })

        version = "11.3.0"
        result[-1]['manifests'].append({
            "download_checksum": "a000bdeeb225145a1450c1b9b1094ef71c13fc4de2ab300a65acbf51cd107c7d",
            "download_url": f"https://github.com/mmozeiko/build-gcc-arm/releases/download/gcc-v{version}/gcc-v{version}-{arch}.7z",
            "version": version,
            "unzip_method": 'default',
            "executables": [
                {
                    "path": f"bin/{arch}-g++.exe",
                    "checksum": "47eaef0e603c9fcae18f2efada305888503e878053119ede3a9e0b8b8beac2ee",
                    "symlink": [f"{arch}-g++-{version}.exe"],
                    "add_to_devenv_path": False,
                },
                {
                    "path": f"bin/{arch}-gcc.exe",
                    "checksum": "205d0b05d64bc80908deb5a64e5f3bf8769cfc08b272835f97aaeaec13ccd533",
                    "symlink": [f"{arch}-gcc-{version}.exe"],
                    "add_to_devenv_path": False,
                },
            ],
            "add_to_devenv_script": [],
        })

        version = "10.3.0"
        result[-1]['manifests'].append({
            "download_checksum": "095ab5a12059fa5dc59f415c059eb577f443a766eb1dd312fbede0f59940f432",
            "download_url": f"https://github.com/mmozeiko/build-gcc-arm/releases/download/gcc-v{version}/gcc-v{version}-{arch}.7z",
            "version": version,
            "unzip_method": 'default',
            "executables": [
                {
                    "path": f"bin/{arch}-g++.exe",
                    "checksum": "f2b2d3c6dab0f84a151835540f25e6d6f9442d00bf546bc4c709fad4b6fdda06",
                    "symlink": [f"{arch}-g++-{version}.exe"],
                    "add_to_devenv_path": False,
                },
                {
                    "path": f"bin/{arch}-gcc.exe",
                    "checksum": "95a8478ecb5133029f3058fb0207f19ee00157a6dd81f220e8308305f0e25fe8",
                    "symlink": [f"{arch}-gcc-{version}.exe"],
                    "add_to_devenv_path": False,
                },
            ],
            "add_to_devenv_script": [],
        })

    # --------------------------------------------------------------------------

    if is_windows:
        result.append({
            "label": "GCC_MinGW_ARM",
            "manifests": [],
        })

        arch = "arm-none-eabi"
        version = "12.2.0"
        result[-1]['manifests'].append({
            "download_checksum": "aa581b3a5d446bb2d9827f2ea1f02b066b6713d4543d24abbd3181f626036c39",
            "download_url": f"https://github.com/mmozeiko/build-gcc-arm/releases/download/gcc-v{version}/gcc-v{version}-{arch}.7z",
            "version": version,
            "unzip_method": 'default',
            "executables": [
                {
                    "path": f"bin/{arch}-g++.exe",
                    "checksum": "fa48985c43cf82b426c461381e4c50d0ac3e9425f7e97bf116e1bab4b3a2a388",
                    "symlink": [f"{arch}-g++-{version}.exe"],
                    "add_to_devenv_path": True,
                },
                {
                    "path": f"bin/{arch}-gcc.exe",
                    "checksum": "94a342aae99cae1a95f3636bb5c7b11f5e17015aee98b556989944ec38755be2",
                    "symlink": [f"{arch}-gcc-{version}.exe"],
                    "add_to_devenv_path": True,
                },
            ],
            "add_to_devenv_script": [],
        })

        version = "11.3.0"
        result[-1]['manifests'].append({
            "download_checksum": "797ed71f60fae386c8875bb4e75e244afb15ded9e00ac77b6670a62be7614cc6",
            "download_url": f"https://github.com/mmozeiko/build-gcc-arm/releases/download/gcc-v{version}/gcc-v{version}-{arch}.7z",
            "version": version,
            "unzip_method": 'default',
            "executables": [
                {
                    "path": f"bin/{arch}-g++.exe",
                    "checksum": "a36f2ea6846badf7c91631f118e88967f25d6e479a9beea158445ce75403a655",
                    "symlink": [f"{arch}-g++-{version}.exe"],
                    "add_to_devenv_path": False,
                },
                {
                    "path": f"bin/{arch}-gcc.exe",
                    "checksum": "71158642a3d4921eda106a1b23640f1ed8bf1725ceaa98cbc8729a9a8115b09a",
                    "symlink": [f"{arch}-gcc-{version}.exe"],
                    "add_to_devenv_path": False,
                },
            ],
            "add_to_devenv_script": [],
        })

        version = "10.3.0"
        result[-1]['manifests'].append({
            "download_checksum": "af0fc2da062aa6423a91213e231ecc5981136b9b0655837ebdbbc5ad879d2d9e",
            "download_url": f"https://github.com/mmozeiko/build-gcc-arm/releases/download/gcc-v{version}/gcc-v{version}-{arch}.7z",
            "version": version,
            "unzip_method": 'default',
            "executables": [
                {
                    "path": f"bin/{arch}-g++.exe",
                    "checksum": "c3dc49b561d177b3586992dfea86067eb8799e1586a7f26cea5b0ea97926632e",
                    "symlink": [f"{arch}-g++-{version}.exe"],
                    "add_to_devenv_path": False,
                },
                {
                    "path": f"bin/{arch}-gcc.exe",
                    "checksum": "7e680ffec593474a54193f5253b620cf59b6e3a1720dd35ab95bcb53582b7b7d",
                    "symlink": [f"{arch}-gcc-{version}.exe"],
                    "add_to_devenv_path": False,
                },
            ],
            "add_to_devenv_script": [],
        })

    # --------------------------------------------------------------------------

    if is_windows:
        result.append({
            "label": "GCC_MinGW",
            "manifests": [],
        })

        version = "12.2.0"
        mingw_version = "10.0.0"
        result[-1]['manifests'].append({
            "download_checksum": "5cbe5ea7533f6d24af3a57fe7022032f420b15d7c4e38c0d16534a42d33213a4",
            "download_url": f"https://github.com/mmozeiko/build-gcc/releases/download/gcc-v{version}-mingw-v{mingw_version}/gcc-v{version}-mingw-v{mingw_version}-x86_64.7z",
            "version": version,
            "unzip_method": 'default',
            "executables": [
                {
                    "path": f"bin/g++.exe",
                    "checksum": "886b0f25256ddbd0f4ad09e6e3b81279f9a8b6a1b5c32c714c9c201d802caa39",
                    "symlink": [f"g++-{version}.exe"],
                    "add_to_devenv_path": True,
                },
                {
                    "path": f"bin/gcc.exe",
                    "checksum": "91c910fa5257fdfd0291c347c81a73c7facb1f486dba941f977714672895c96e",
                    "symlink": [f"gcc-{version}.exe"],
                    "add_to_devenv_path": True,
                },
            ],
            "add_to_devenv_script": [],
        })

        version = "11.3.0"
        result[-1]['manifests'].append({
            "download_checksum": "e2c5c64659aeda77680c5eec80bbaa4db3f117b21febeb3f13fd76d580604fd0",
            "download_url": f"https://github.com/mmozeiko/build-gcc/releases/download/gcc-v{version}-mingw-v{mingw_version}/gcc-v{version}-mingw-v{mingw_version}-x86_64.7z",
            "version": version,
            "unzip_method": 'default',
            "executables": [
                {
                    "path": f"bin/g++.exe",
                    "checksum": "e92ecfa0171f2ab0c3ca39f2121ab5e887b3a378399a4be7e056820f5841c7a5",
                    "symlink": [f"g++-{version}.exe"],
                    "add_to_devenv_path": False,
                },
                {
                    "path": f"bin/gcc.exe",
                    "checksum": "f3226120196ea37ab3e450bd0f26d816ee28556d18aa0de64c3e427f31d66eeb",
                    "symlink": [f"gcc-{version}.exe"],
                    "add_to_devenv_path": False,
                },
            ],
            "add_to_devenv_script": [],
        })

        version = "10.3.0"
        mingw_version = "8.0.0"
        result[-1]['manifests'].append({
            "download_checksum": "c8f38f6b1d264d7e008009bd32a04ca71b4ee3a3113e67930ab31c2e06818317",
            "download_url": f"https://github.com/mmozeiko/build-gcc/releases/download/gcc-v{version}-mingw-v{mingw_version}/gcc-v{version}-mingw-v{mingw_version}-x86_64.7z",
            "version": version,
            "unzip_method": 'default',
            "executables": [
                {
                    "path": f"bin/g++.exe",
                    "checksum": "5c93b6da129ea01ee5fc87d5c7db948fc3bc62bae261ded9a883f1fa543571d2",
                    "symlink": [f"g++-{version}.exe"],
                    "add_to_devenv_path": False,
                },
                {
                    "path": f"bin/gcc.exe",
                    "checksum": "54a5f8d09e6741b9c94d1494f383c424c20449e3e06f36bf96603aeda9874405",
                    "symlink": [f"gcc-{version}.exe"],
                    "add_to_devenv_path": False,
                },
            ],
            "add_to_devenv_script": [],
        })

    # --------------------------------------------------------------------------

    result.append({
        "label": "LLVM",
        "manifests": [],
    })

    version           = ""
    download_url      = ""
    download_checksum = ""
    executables       = []
    unzip_method      = "default"

    if is_windows:
        version           = "15.0.7"
        download_url      = f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/LLVM-{version}-win64.exe"
        download_checksum = "5428cb72acf63ce3bc4328e546a36674c9736ec040ecc176d362201c6548e6a8"
        unzip_method      = '7zip'
        executables = [
            {
                "path": f"bin/clang++.exe",
                "checksum": "1f523e33de4ce9d591b4eb9bad102f086e8480488148f8db0d5c87056798ce3e",
                "symlink": [f"clang++-{version}.exe"],
                "add_to_devenv_path": True,
            },
            {
                "path": f"bin/clang.exe",
                "checksum": "1f523e33de4ce9d591b4eb9bad102f086e8480488148f8db0d5c87056798ce3e",
                "symlink": [f"clang-{version}.exe"],
                "add_to_devenv_path": True,
            }
        ]
    else:
        version           = "15.0.6" # No linux release for 15.0.7
        download_url      = f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/clang+llvm-{version}-x86_64-linux-gnu-ubuntu-18.04.tar.xz"
        download_checksum = "38bc7f5563642e73e69ac5626724e206d6d539fbef653541b34cae0ba9c3f036"
        executables = [
            {
                "path": f"bin/clang++",
                "checksum": "388be41dc565a891ced9e78da2e89a249ca9b9a26f71a3c912e8ba89585be89c",
                "symlink": [f"clang++-{version}"],
                "add_to_devenv_path": True,
            },
            {
                "path": f"bin/clang",
                "checksum": "388be41dc565a891ced9e78da2e89a249ca9b9a26f71a3c912e8ba89585be89c",
                "symlink": [f"clang-{version}"],
                "add_to_devenv_path": True,
            }
        ]

    result[-1]['manifests'].append({
        "download_checksum": download_checksum,
        "download_url": download_url,
        "version": version,
        "unzip_method": unzip_method,
        "executables": executables,
        "add_to_devenv_script": [],
    })

    if is_windows:
        version           = "14.0.6"
        download_url      = f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/LLVM-{version}-win64.exe"
        download_checksum = "e8dbb2f7de8e37915273d65c1c2f2d96844b96bb8e8035f62c5182475e80b9fc"
        executables = [
            {
                "path": f"bin/clang++.exe",
                "checksum": "d557b79bc09a01141ac7d940016f52ce1db081e31d7968f0d9b6f4c192d8f8cc",
                "symlink": [f"clang++-{version}.exe"],
                "add_to_devenv_path": False,
            },
            {
                "path": f"bin/clang.exe",
                "checksum": "d557b79bc09a01141ac7d940016f52ce1db081e31d7968f0d9b6f4c192d8f8cc",
                "symlink": [f"clang-{version}.exe"],
                "add_to_devenv_path": False,
            }
        ]
    else:
        version           = "14.0.0" # Only version with linux downloads
        download_url      = f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/clang+llvm-{version}-x86_64-linux-gnu-ubuntu-18.04.tar.xz"
        download_checksum = "61582215dafafb7b576ea30cc136be92c877ba1f1c31ddbbd372d6d65622fef5"
        executables = [
            {
                "path": f"bin/clang++",
                "checksum": "3557c2deadae7e2bc3bffce4afd93ddab6ef50090971c8ce3bf15c80b27134a0",
                "symlink": [f"clang++-{version}"],
                "add_to_devenv_path": False,
            },
            {
                "path": f"bin/clang",
                "checksum": "3557c2deadae7e2bc3bffce4afd93ddab6ef50090971c8ce3bf15c80b27134a0",
                "symlink": [f"clang-{version}"],
                "add_to_devenv_path": False,
            }
        ]

    result[-1]['manifests'].append({
        "download_checksum": download_checksum,
        "download_url": download_url,
        "version": version,
        "unzip_method": unzip_method,
        "executables": executables,
        "add_to_devenv_script": [],
    })

    version = "13.0.1"
    if is_windows:
        download_url      = f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/LLVM-{version}-win64.exe"
        download_checksum = "9d15be034d52ec57cfc97615634099604d88a54761649498daa7405983a7e12f"
        executables = [
            {
                "path": f"bin/clang++.exe",
                "checksum": "e3f26820ac446cb7c471cce49f6646b4346aa5380d11790ceaa7bf494a94b21d",
                "symlink": [f"clang++-{version}.exe"],
                "add_to_devenv_path": False,
            },
            {
                "path": f"bin/clang.exe",
                "checksum": "e3f26820ac446cb7c471cce49f6646b4346aa5380d11790ceaa7bf494a94b21d",
                "symlink": [f"clang-{version}.exe"],
                "add_to_devenv_path": False,
            }
        ]
    else:
        download_checksum = "84a54c69781ad90615d1b0276a83ff87daaeded99fbc64457c350679df7b4ff0"
        download_url      = f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/clang+llvm-{version}-x86_64-linux-gnu-ubuntu-18.04.tar.xz"
        executables = [
            {
                "path": f"bin/clang++",
                "checksum": "ae47e6cc9f6d95f7a39e4800e511b7bdc3f55464ca79e45cd63cbd8a862a82a1",
                "symlink": [f"clang++-{version}"],
                "add_to_devenv_path": False,
            },
            {
                "path": f"bin/clang",
                "checksum": "ae47e6cc9f6d95f7a39e4800e511b7bdc3f55464ca79e45cd63cbd8a862a82a1",
                "symlink": [f"clang-{version}"],
                "add_to_devenv_path": False,
            }
        ]

    result[-1]['manifests'].append({
        "download_checksum": download_checksum,
        "download_url": download_url,
        "version": version,
        "unzip_method": unzip_method,
        "executables": executables,
        "add_to_devenv_script": [],
    })

    version = "12.0.1"
    if is_windows:
        download_checksum = "fcbabc9a170208bb344f7bba8366cca57ff103d72a316781bbb77d634b9e9433"
        download_url      = f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/LLVM-{version}-win64.exe"
        executables = [
            {
                "path": f"bin/clang++.exe",
                "checksum": "9f0748de7f946c210a030452de226986bab46a0121d7236ea0e7b5079cb6dfef",
                "symlink": [f"clang++-{version}.exe"],
                "add_to_devenv_path": False,
            },
            {
                "path": f"bin/clang.exe",
                "checksum": "9f0748de7f946c210a030452de226986bab46a0121d7236ea0e7b5079cb6dfef",
                "symlink": [f"clang-{version}"],
                "add_to_devenv_path": False,
            }
        ]
    else:
        download_checksum = "6b3cc55d3ef413be79785c4dc02828ab3bd6b887872b143e3091692fc6acefe7"
        download_url      = f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/clang+llvm-{version}-x86_64-linux-gnu-ubuntu-16.04.tar.xz"
        executables = [
            {
                "path": f"bin/clang++",
                "checksum": "329bba976c0cef38863129233a4b0939688eae971c7a606d41dd0e5a53d53455",
                "symlink": [f"clang++-{version}"],
                "add_to_devenv_path": False,
            },
            {
                "path": f"bin/clang",
                "checksum": "329bba976c0cef38863129233a4b0939688eae971c7a606d41dd0e5a53d53455",
                "symlink": [f"clang-{version}"],
                "add_to_devenv_path": False,
            }
        ]

    result[-1]['manifests'].append({
        "download_checksum": download_checksum,
        "download_url": download_url,
        "version": version,
        "unzip_method": unzip_method,
        "executables": executables,
        "add_to_devenv_script": [],
    })

    version = "11.1.0"
    if is_windows:
        download_checksum = "b5770bbfac712d273938cd155e232afaa85c2e8d865c7ca504a104a838568516"
        download_url      = f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/LLVM-{version}-win64.exe"
        executables = [
            {
                "path": f"bin/clang++.exe",
                "checksum": "f72591f8a02e4b7573aa2fcd2999a3ea76fe729e2468e5414853617268798dfd",
                "symlink": [f"clang++-{version}.exe"],
                "add_to_devenv_path": False,
            },
            {
                "path": f"bin/clang.exe",
                "checksum": "f72591f8a02e4b7573aa2fcd2999a3ea76fe729e2468e5414853617268798dfd",
                "symlink": [f"clang-{version}.exe"],
                "add_to_devenv_path": False,
            }
        ]
    else:
        download_checksum = "c691a558967fb7709fb81e0ed80d1f775f4502810236aa968b4406526b43bee1"
        download_url      = f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/clang+llvm-{version}-x86_64-linux-gnu-ubuntu-16.04.tar.xz"
        executables = [
            {
                "path": f"bin/clang++",
                "checksum": "656bfde194276cee81dc8a7a08858313c5b5bdcfa18ac6cd6116297af2f65148",
                "symlink": [f"clang++-{version}"],
                "add_to_devenv_path": False,
            },
            {
                "path": f"bin/clang",
                "checksum": "656bfde194276cee81dc8a7a08858313c5b5bdcfa18ac6cd6116297af2f65148",
                "symlink": [f"clang-{version}"],
                "add_to_devenv_path": False,
            }
        ]

    result[-1]['manifests'].append({
        "download_checksum": download_checksum,
        "download_url": download_url,
        "version": version,
        "unzip_method": unzip_method,
        "executables": executables,
        "add_to_devenv_script": [],
    })

    # --------------------------------------------------------------------------

    version           = "1.11.1"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""

    if is_windows:
        download_url      = f"https://github.com/ninja-build/ninja/releases/download/v{version}/ninja-win.zip"
        download_checksum = "524b344a1a9a55005eaf868d991e090ab8ce07fa109f1820d40e74642e289abc"
        checksum          = "23e7d60c17b3fcd42d9c00d49eca3c3771b04d7ccb13e49836b06b34e20211c7"
        exe_path          = "ninja.exe"
    else:
        download_url      = f"https://github.com/ninja-build/ninja/releases/download/v{version}/ninja-linux.zip"
        download_checksum = "b901ba96e486dce377f9a070ed4ef3f79deb45f4ffe2938f8e7ddc69cfb3df77"
        checksum          = "ac35c7992e95c5f2cadb44097d9988bcc71e5e39d9908ec312eb46872844f2e8"
        exe_path          = "ninja"

    result.append({
        "label": "Ninja",
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
                        "add_to_devenv_path": True,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": [],
             }
        ],
    })

    # --------------------------------------------------------------------------

    label                = "NodeJS"
    version              = "16.19.0"
    download_url         = ""
    download_checksum    = ""
    exe_path             = ""
    checksum             = ""
    symlink              = []
    add_to_devenv_script = []

    if is_windows:
        download_url      = f"https://nodejs.org/dist/v{version}/node-v{version}-win-x64.7z"
        download_checksum = "e07399a4a441091ca0a5506faf7a9236ea1675220146daeea3bee828c2cbda3f"
        checksum          = "e4e7f389fbec9300275defc749246c62bdbe4f66406eb01e7c9a4101e07352da"
        exe_path          = "node.exe"
        symlink           = [f"node-{version}.exe"]
    else:
        download_url      = f"https://nodejs.org/dist/v{version}/node-v{version}-linux-x64.tar.xz"
        download_checksum = "c88b52497ab38a3ddf526e5b46a41270320409109c3f74171b241132984fd08f"
        checksum          = "45afcfc9a45df626e8aa2b883753d1cf7f222ad9243f3003d1aa372696120df6"
        exe_path          = "bin/node"
        symlink           = [f"node-{version}"]

    result.append({
        "label": "NodeJS",
        "manifests": [
            {
                "download_checksum": download_checksum,
                "download_url": download_url,
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
                "add_to_devenv_script": add_to_devenv_script,
            }
        ],
    })

    version = "18.15.0"
    if is_windows:
        download_url      = f"https://nodejs.org/dist/v{version}/node-v{version}-win-x64.7z"
        download_checksum = "cad3cc0910dc216e8b6dcfc3c5b3be0a619c2d4a4b29f2e674820b70e4f374dd"
        checksum          = "17fd75d8a41bf9b4c475143e19ff2808afa7a92f7502ede731537d9da674d5e8"
        symlink           = [f"node-{version}.exe"]
        add_to_devenv_script = [
            f"set PATH=%~dp0{label}\\{version}\\node_modules\\corepack\\shims;%PATH%",
        ]
    else:
        download_url      = f"https://nodejs.org/dist/v{version}/node-v{version}-linux-x64.tar.xz"
        download_checksum = "c8c5fa53ce0c0f248e45983e86368e0b1daf84b77e88b310f769c3cfc12682ef"
        checksum          = "a2a40807f57c1c215ddb996e71e4f30b93e375cab2bfb725287b8a1f51fd1e7a"
        symlink           = [f"node-{version}"]


    result.append({
        "label": "NodeJS",
        "manifests": [
            {
                "download_checksum": download_checksum,
                "download_url": download_url,
                "version": version,
                "unzip_method": 'default',
                "executables": [
                    {
                        "path": exe_path,
                        "symlink": symlink,
                        "add_to_devenv_path": True,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": add_to_devenv_script,
            }
        ],
    })

    # --------------------------------------------------------------------------

    label                = "Python"
    date                 = "20230116"
    version              = f"3.10.9+{date}"
    download_url         = ""
    download_checksum    = ""
    exe_path             = ""
    checksum             = ""
    add_to_devenv_script = []

    if is_windows:
        download_url         = f"https://github.com/indygreg/python-build-standalone/releases/download/{date}/cpython-{version}-x86_64-pc-windows-msvc-shared-pgo-full.tar.zst"
        download_checksum    = "4cfa6299a78a3959102c461d126e4869616f0a49c60b44220c000fc9aecddd78"
        checksum             = "6dafb845aba67aba898f5aa8adf6c48061e7ffea1d2ed7d290a1e4386e78f2f0"
        exe_path             = "install/python.exe"
        add_to_devenv_script = [
            f"set PYTHONHOME=%~dp0{label}\\{version}\\install",
            f"set PATH=%~dp0{label}\\{version}\\install\\Script;%PATH%",
        ]
    else:
        download_url      = f"https://github.com/indygreg/python-build-standalone/releases/download/{date}/cpython-{version}-x86_64_v2-unknown-linux-gnu-pgo+lto-full.tar.zst"
        download_checksum = "49f4a8c02efff2debbb258973b1f6efbd568e4be2e5dca07c7dcd754a7bff9cf"
        checksum          = "none"
        exe_path          = "bin/python"

    # TODO: Get ZST somehow on linux
    if is_windows:
        result.append({
            "label": label,
            "manifests": [
                {
                    "download_checksum": download_checksum,
                    "download_url": download_url,
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": exe_path,
                            "symlink": [],
                            "add_to_devenv_path": True,
                            "checksum": checksum,
                        }
                    ],
                    "add_to_devenv_script": add_to_devenv_script,
                }
            ],
        })

    # --------------------------------------------------------------------------

    version              = "1.24"
    download_url         = ""
    download_checksum    = ""
    exe_path             = ""
    checksum             = ""

    if is_windows:
        download_url         = f"https://renderdoc.org/stable/{version}/RenderDoc_{version}_64.zip"
        download_checksum    = "dbd215f7e1c7933b8eedc49499a4372c92e68ddab04af4658f434bfe6c382a9a"
        checksum             = "cfb96468355a416568faf89db18cd8a195bccec87ea16b3fffd3cc13c952c5fd"
        exe_path             = "qrenderdoc.exe"
    else:
        download_url      = f"https://renderdoc.org/stable/{version}/renderdoc_{version}.tar.gz"
        download_checksum = "fbdf67131ade655a7e635aa34e8b6fcd1aac9d88ebbe7d3da39fb075e05b1f41"
        checksum          = "00508f6532f73a38873b92777fa8b7fb317c0b5f411fb50d2722823027993252"
        exe_path          = "bin/qrenderdoc"

    result.append({
        "label": "Renderdoc",
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
        version = "0.7.0"
        result.append({
            "label": "Zeal",
            "manifests": [
                {
                    "download_url": f"https://github.com/zealdocs/zeal/releases/download/v{version}/zeal-{version}-portable--windows-x64.7z",
                    "download_checksum": "e99a11a5692f8ca93da55589b23d20bf40edc9a3f9d78f7d58e0c55f8bd0acac",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "zeal.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "579188849d64d2f7703f46102573cda13bd50d80ab6c8c88177c1b6d324f14b8",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    version           = "0.10.1"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""
    symlink           = []

    if is_windows:
        download_url      = f"https://ziglang.org/download/{version}/zig-windows-x86_64-{version}.zip"
        download_checksum = "5768004e5e274c7969c3892e891596e51c5df2b422d798865471e05049988125"
        checksum          = "607c9928a24f9d2e08df1ee240ebfd15ab1eb3c14b85e02f7dad6f8c8b53fea8"
        exe_path          = "zig.exe"
        symlink           = [f"zig-{version}.exe"]
    else:
        download_url      = f"https://ziglang.org/download/{version}/zig-linux-x86_64-{version}.tar.xz"
        download_checksum = "6699f0e7293081b42428f32c9d9c983854094bd15fee5489f12c4cf4518cc380"
        checksum          = "b298cd869e11709b9c7a1313315b5ea2a9d8a0718f555c6990ee209d7c533442"
        exe_path          = "zig"
        symlink           = [f"zig-{version}"]

    result.append({
        "label": "Zig",
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
                        "add_to_devenv_path": True,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    if is_windows:
        version  = "1.4.13"
        git_hash = "0066c6"
        result.append({
            "label": "Clink",
            "manifests": [
                {
                    "download_url": f"https://github.com/chrisant996/clink/releases/download/v{version}/clink.{version}.{git_hash}.zip",
                    "download_checksum": "800f7657d73a00dad40d46c9317bd418172ee40cc8b3958e32fba1f0b596e829",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "clink_x64.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "331266334f59f2c978ff8e13bbcadb218051e790b61d9cc69e85617276c51298",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    if is_windows:
        version = "1.11.1"
        result.append({
            "label": "Dependencies",
            "manifests": [
                {
                    "download_url": f"https://github.com/lucasg/Dependencies/releases/download/v{version}/Dependencies_x64_Release.zip",
                    "download_checksum": "7d22dc00f1c09fd4415d48ad74d1cf801893e83b9a39944b0fce6dea7ceaea99",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "DependenciesGui.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "1737e5406128c3560bbb2bced3ac62d77998e592444f94b10cc0aa0bb1e617e6",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    version           = "0.37.0"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""
    symlink           = []

    if is_windows:
        download_url      = f"https://github.com/junegunn/fzf/releases/download/{version}/fzf-{version}-windows_amd64.zip"
        download_checksum = "247bffe84ff3294a8c0a7bb96329d5e4152d3d034e13dec59dcc97d8a828000d"
        checksum          = "c0f4b20d0602977ff3e592cac8eadf86473abed0d24e2def81239bd2e76047e8"
        exe_path          = "fzf.exe"
        symlink           = [f"fzf.exe"]
    else:
        download_url      = f"https://github.com/junegunn/fzf/releases/download/{version}/fzf-{version}-linux_amd64.tar.gz"
        download_checksum = "ffa3220089f2ed6ddbef2d54795e49f46467acfadd4ad0d22c5f07c52dc0d4ab"
        checksum          = "6475c41e56d949da753782fef56017657b77846f23e71fca88378e3f55c1d6d0"
        exe_path          = "fzf"
        symlink           = [f"fzf"]

    result.append({
        "label": "FZF",
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

    # --------------------------------------------------------------------------

    version           = "0.9.1"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""
    symlink           = []

    if is_windows:
        download_url      = f"https://github.com/neovim/neovim/releases/download/v{version}/nvim-win64.zip"
        download_checksum = "af41890b8c14d4ed214a2ef6c1ab8e0be004eac7094d5df1cc4bc17ccf0a13ef"
        checksum          = "53d68005bbbf974fe89bf74f14d926d27a7ac29d008c9a5182da82a8b9817719"
        exe_path          = "bin/nvim.exe"
    else:
        exe_path          = "nvim.appimage"
        download_url      = f"https://github.com/neovim/neovim/releases/download/v{version}/nvim.appimage"
        download_checksum = "262892176e21da0902c4f0b1e027d54d21b4bcae6b0397afccd8a81b476c3055"
        checksum          = download_checksum
        symlink           = ["nvim", "vim"] # Usually use VM with no desktop-environment

    result.append({
        "label": "NVim",
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
                        "add_to_devenv_path": True,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version           = "0.11.0"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""

    if is_windows:
        download_url      = f"https://github.com/neovide/neovide/releases/download/{version}/neovide.exe.zip"
        download_checksum = "68c431b4f97e56bc27d937e29a46fb7a677f18645635944c5cef2a7c9b013b45"
        checksum          = "dc48fc61c65e74ca16e389ac35c524650c3a949e695f91ae4cb9e8b813b07384"
        exe_path          = "neovide.exe"
    else:
        download_url      = f"https://github.com/neovide/neovide/releases/download/{version}/neovide.AppImage"
        download_checksum = "9eb3afd5c6abc84cf200219ff494f2a49c5ed0d0366fd510b4aa91d7412a8a50"
        checksum          = "9eb3afd5c6abc84cf200219ff494f2a49c5ed0d0366fd510b4aa91d7412a8a50"
        exe_path          = "neovide.AppImage"

    result.append({
        "label": "Neovide",
        "manifests": [
            {
                "download_url": download_url,
                "download_checksum": download_checksum,
                "version": version,
                "unzip_method": 'default',
                "executables": [
                    {
                        "path": exe_path,
                        "symlink": [exe_path],
                        "add_to_devenv_path": False,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version           = "1.26.2"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""

    if is_windows:
        download_url      = f"https://github.com/WerWolv/ImHex/releases/download/v{version}/imhex-{version}-Windows-Portable.zip"
        download_checksum = "4f58097c3ccee88d8dff0d48da0f239af8a9d444903cc19a3369f63caa8d77e6"
        checksum          = "ddd448c0d8fe71295bbcc5b52c9e9f4b06956a79572b7d634436a49728f5f341"
        exe_path          = "imhex.exe"
    else:
        exe_path          = f"imhex-{version}.AppImage"
        download_url      = f"https://github.com/WerWolv/ImHex/releases/download/v{version}/{exe_path}"
        download_checksum = "229d7f2f36dca0d4aa2eeb4f637114ffa94db7d67db74b34ed7eda34d72e4bed"
        checksum          = download_checksum

    result.append({
        "label": "ImHex",
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

    version           = "13.0.0"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""

    if is_windows:
        download_url      = f"https://github.com/BurntSushi/ripgrep/releases/download/{version}/ripgrep-{version}-x86_64-pc-windows-msvc.zip"
        download_checksum = "a47ace6f654c5ffa236792fc3ee3fefd9c7e88e026928b44da801acb72124aa8"
        checksum          = "ab5595a4f7a6b918cece0e7e22ebc883ead6163948571419a1dd5cd3c7f37972"
        exe_path          = "rg.exe"
    else:
        download_url      = f"https://github.com/BurntSushi/ripgrep/releases/download/{version}/ripgrep-{version}-x86_64-unknown-linux-musl.tar.gz"
        download_checksum = "ee4e0751ab108b6da4f47c52da187d5177dc371f0f512a7caaec5434e711c091"
        checksum          = "4ef156371199b3ddac1bf584e0e52b1828279af82e4ea864b4d9c816adb5db40"
        exe_path          = "rg"

    result.append({
        "label": "Ripgrep",
        "manifests": [
            {
                "download_url": download_url,
                "download_checksum": download_checksum,
                "version": version,
                "unzip_method": 'default',
                "executables": [
                    {
                        "path": exe_path,
                        "symlink": [exe_path],
                        "add_to_devenv_path": False,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version              = "8.7.0"
    download_url         = ""
    download_checksum    = ""
    exe_path             = ""
    checksum             = ""
    add_to_devenv_script = []

    fd_args='''fd \
--type file \
--no-ignore-vcs \
--strip-cwd-prefix \
--hidden \
--follow \
--exclude .git \
--exclude .cache \
--exclude .vs \
--exclude "*.dll" \
--exclude "*.exe" \
--exclude "*.lib" \
--exclude "*.obj" \
--exclude "*.pdb" \
--exclude "*.so" \
--exclude "*.tar" \
--exclude "*.zip" \
'''

    if is_windows:
        download_url         = f"https://github.com/sharkdp/fd/releases/download/v{version}/fd-v{version}-x86_64-pc-windows-msvc.zip"
        download_checksum    = "657cf430a1b349ce2b9cceeaed0b14220a417bbf24a85995aa6fbf8f746f4e03"
        checksum             = "0fd887ffa5b2f36cb77934072ca60d86c42e5afda90ac7005d7f1ef076ca70c6"
        exe_path             = "fd.exe"
        add_to_devenv_script = [
            "set FZF_DEFAULT_OPTS=--multi --layout=reverse",
            f"set FZF_DEFAULT_COMMAND={fd_args}"
        ]
    else:
        download_url      = f"https://github.com/sharkdp/fd/releases/download/v{version}/fd-v{version}-x86_64-unknown-linux-musl.tar.gz"
        download_checksum = "ced2541984b765994446958206b3411f3dea761a5e618cb18b4724c523727d68"
        checksum          = "3533a356ff5dac034b6b37ef72f61a0132ffcd54c1d321bf2676d78c3cb499d8"
        exe_path          = "fd"
        add_to_devenv_script = [
            "FZF_DEFAULT_OPTS=\"--multi --layout=reverse\"",
            f"FZF_DEFAULT_COMMAND=\"{fd_args}\""
        ]

    result.append({
        "label": "Fd",
        "manifests": [
            {
                "download_url": download_url,
                "download_checksum": download_checksum,
                "version": version,
                "unzip_method": 'default',
                "executables": [
                    {
                        "path": exe_path,
                        "symlink": [exe_path],
                        "add_to_devenv_path": False,
                        "checksum": checksum
                    }
                ],
                "add_to_devenv_script": add_to_devenv_script,
            }
        ],
    })

    # --------------------------------------------------------------------------

    if is_windows:
        version           = "2.16.01"
        exe_path          = "nasm.exe"
        download_url      = f"https://www.nasm.us/pub/nasm/releasebuilds/{version}/win64/nasm-{version}-win64.zip"
        download_checksum = "029eed31faf0d2c5f95783294432cbea6c15bf633430f254bb3c1f195c67ca3a"
        checksum          = "edd81d22451246758450f1d5bd7f4c64937ed6cee06f3c2bbbba82401b32c6d4"
        symlink           = [f"nasm-{version}.exe"]

        result.append({
            "label": "NASM",
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
                            "add_to_devenv_path": True,
                            "checksum": checksum,
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    version = "3.52.0"
    symlink = []

    if is_windows:
        exe_path          = "losslesscut.exe"
        download_url      = f"https://github.com/mifi/lossless-cut/releases/download/v{version}/LosslessCut-win-x64.7z"
        download_checksum = "fa554d5f63f7287d6b4b6bf19ac5916c99cabfe9ac22248e7a3c39898c5b56ff"
        checksum          = "3cae40fa13523e9dfe760521d167174ddfc21105eb20466e905eb39b74e8ed70"
    else:
        exe_path          = f"LosslessCut-linux-x86_64.AppImage"
        download_url      = f"https://github.com/mifi/lossless-cut/releases/download/v{version}/{exe_path}"
        download_checksum = "28daafe9fcd07473f460c0a903164efe93d4e5ce7e682b6f318a5550c34bdb99"
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

    # --------------------------------------------------------------------------

    version           = "1.20.1"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""

    if is_windows:
        exe_path          = "bin/go.exe"
        download_url      = f"https://go.dev/dl/go{version}.windows-amd64.zip"
        download_checksum = "3b493969196a6de8d9762d09f5bc5ae7a3e5814b0cfbf9cc26838c2bc1314f9c"
        checksum          = "89fc8e2c47f2a2a9138e60159781ce377167cf61e30d8136fbad0d77ac9303ed"
        symlink           = [f"go-{version}.exe"]
    else:
        exe_path          = f"bin/go"
        download_url      = f"https://go.dev/dl/go{version}.linux-amd64.tar.gz"
        download_checksum = "000a5b1fca4f75895f78befeb2eecf10bfff3c428597f3f1e69133b63b911b02"
        checksum          = "dfaaf2d9212757e0c305c9554f616cac6744de646ef6ef20f5eaf9d9634771c3"
        symlink           = [f"go-{version}"]

    result.append({
        "label": "Go",
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
                        "add_to_devenv_path": True,
                        "checksum": checksum,
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    if is_windows:
        version           = "1.7"
        exe_path          = "jq-windows-amd64.exe"
        download_url      = f"https://github.com/jqlang/jq/releases/download/jq-{version}/jq-windows-amd64.exe"
        download_checksum = "2e9cc54d0a5d098e2007decec1dbb3c555ca2f5aabded7aec907fe0ffe401aab"
        checksum          = download_checksum
        symlink           = [f"jq.exe", f"jq-{version}.exe"]

        result.append({
            "label": "jq",
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
                            "add_to_devenv_path": True,
                            "checksum": checksum,
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    return result
