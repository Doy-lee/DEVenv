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

    version           = "3.24.3"
    download_url      = ""
    exe_path          = ""
    download_checksum = ""
    checksum          = ""
    symlink           = []

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

    version = "3.26.1"
    if is_windows:
        exe_path          = f"bin/cmake.exe"
        download_url      = f"https://github.com/Kitware/CMake/releases/download/v{version}/cmake-{version}-windows-x86_64.zip"
        download_checksum = "a2cefff35caa91e55716f1951ed82db928fc24f14d61641b21851dcddb81a21e"
        checksum          = "2256fbdd018ecd621d462c9a06d9d7a7b0fb9a279e9feead9e6315735a46f175"
        symlink           = [f"cmake-{version}.exe"]
    else:
        exe_path          = f"bin/cmake"
        download_url      = f"https://github.com/Kitware/CMake/releases/download/v{version}/cmake-{version}-linux-x86_64.tar.gz"
        download_checksum = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        checksum          = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
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

    # --------------------------------------------------------------------------

    version           = "1.9.4"
    download_url      = ""
    exe_path          = ""
    download_checksum = ""
    checksum          = ""
    symlink           = []

    if is_windows:
        exe_path          = f"doxygen.exe"
        download_url      = f"https://github.com/doxygen/doxygen/releases/download/Release_{version.replace('.', '_')}/doxygen-{version}.windows.x64.bin.zip"
        download_checksum = "3b34098c5fb016baa1d29aba101fe9d6843213b966b92a6b12c8856c547ee0c4"
        checksum          = "3cb4d89f2b3db7eec2b6797dc6b49cdfe9adda954575898895260f66f312d730"
        symlink           = [f"doxygen-{version}.exe"]
    else:
        exe_path          = f"bin/doxygen"
        download_url      = f"https://github.com/doxygen/doxygen/releases/download/Release_{version.replace('.', '_')}/doxygen-{version}.linux.bin.tar.gz"
        download_checksum = "d157f247d579d0c976bb2595e7806bc4d0ffad105cbe0406b243afa1dc686a32"
        checksum          = "0f03e67bfdc61c6c9dd4ad1412ac2d90b478bfa7ddbd513c3faa9615b5d80c17"
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
        download_checksum = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        checksum          = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
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
        version = "0.6.1"
        result.append({
            "label": "Zeal",
            "manifests": [
                {
                    "download_url": f"https://github.com/zealdocs/zeal/releases/download/v{version}/zeal-portable-{version}-windows-x64.7z",
                    "download_checksum": "08e9992f620ba0a5ea348471d8ac9c85059e95eedd950118928be639746e3f94",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "zeal.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "d1e687a33e117b6319210f40e2401b4a68ffeb0f33ef82f5fb6a31ce4514a423",
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

    if is_windows:
        version = "1.4.1.1022"
        result.append({
            "label": "Everything",
            "manifests": [
                {
                    "download_url": f"https://www.voidtools.com/Everything-{version}.x64.zip",
                    "download_checksum": "c718bcd73d341e64c8cb47e97eb0c45d010fdcc45c2488d4a3a3c51acc775889",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "Everything.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "9c282a47a18477af505e64b45c3609f21f13fe1f6ff289065497a1ec00f5d332",
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

    if is_windows:
        version = "1.1.42"
        result.append({
            "label": "JPEGView",
            "manifests": [
                {
                    "download_url": f"https://github.com/sylikc/jpegview/releases/download/v{version}/JPEGView_{version}.7z",
                    "download_checksum": "84b20a6f3ee5184176e46a6755a57147aba90984c2fbbee094e57af036859daf",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "JPEGView64/JPEGView.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "cd7930d0242cbd8a0d0dc9861e48f6ebe4c2bfba33aafbcf8e0da497ab0eae54",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    if is_windows:
        version = "22.02"
        result.append({
            "label": "MPC-Qt",
            "manifests": [
                {
                    "download_url": f"https://github.com/mpc-qt/mpc-qt/releases/download/v{version}/mpc-qt-win-x64-{version.replace('.', '')}.zip",
                    "download_checksum": "2230c4f4de1a429ccc67e5c590efc0a86fbaffeb33a4dc5f391aa45e660b80c2",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "mpc-qt.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "d7ee46b0d4a61a26f8acd5d5fd4da2d252d6bc80c5cab6a55db06e853f2acefb",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    version           = "0.9.0"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""
    symlink           = []

    if is_windows:
        download_url      = f"https://github.com/neovim/neovim/releases/download/v{version}/nvim-win64.zip"
        download_checksum = "9efe2ff55a13edf32afcfe51194d8e85bb62be7f09ff86384ffb0b8eed2bf716"
        checksum          = "bbaf0b37c0d6df1fb35b9504b518fdb961b69acac67a0de732281e5df359a3b0"
        exe_path          = "bin/nvim.exe"
    else:
        exe_path          = "nvim.appimage"
        download_url      = f"0e1e6d53c6c8055de23bdb33f60bb64af0baf11390669c1b40ecbbf2c7a34547"
        download_checksum = "bb0d4599cb506fc6e29bf0e9cef3b52e06dcb4bb930b56d6eb88320f1d46a908"
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

    version           = "0.10.4"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""

    if is_windows:
        download_url      = f"https://github.com/neovide/neovide/releases/download/{version}/neovide.exe.zip"
        download_checksum = "23b6c3a77e0aacd7178baad41a10220b10028af4bddfa0d7fe9000d76ef54018"
        checksum          = "4fcb79478c9b03cb6706336e95e25468c38d11938f26dd3f18b30f51aaf6e09b"
        exe_path          = "neovide.exe"
    else:
        download_url      = f"https://github.com/neovide/neovide/releases/download/{version}/neovide.AppImage.zip"
        download_checksum = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        checksum          = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        exe_path          = "neovide"

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
                            "path": f"MobaXTerm_Personal_{version}.exe",
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
        version = "3.0.5847"
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

    version              = "8.6.0"
    download_url         = ""
    download_checksum    = ""
    exe_path             = ""
    checksum             = ""
    add_to_devenv_script = []

    if is_windows:
        download_url         = f"https://github.com/sharkdp/fd/releases/download/v{version}/fd-v{version}-x86_64-pc-windows-msvc.zip"
        download_checksum    = "9cff97eb1c024ed94cc76a4b2d924ab3df04b37e7430c282b8188a13f1653ebe"
        checksum             = "a93ab08528896556ba3a6c262c8d73b275df2ce7a4138f5323f3eff414403f33"
        exe_path             = "fd.exe"
        add_to_devenv_script = [
            "set FZF_DEFAULT_OPTS=--multi --layout=reverse",
            "set FZF_DEFAULT_COMMAND=fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude .cache --exclude .vs",
        ]
    else:
        download_url      = f"https://github.com/sharkdp/fd/releases/download/v{version}/fd-v{version}-x86_64-unknown-linux-musl.tar.gz"
        download_checksum = "9fdb370648fb8256fc9a36355c652546bd4c62925babcad80f95f90f74fc81e7"
        checksum          = "702eb951e6b37be64cca66da976e0fcb0be587121034c1d6f841ce7fad3bd8e3"
        exe_path          = "fd"
        add_to_devenv_script = [
            "FZF_DEFAULT_OPTS=\"--multi --layout=reverse\"",
            "FZF_DEFAULT_COMMAND=\"fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude .cache --exclude .vs\"",
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
        version = "4_12"
        result.append({
            "label": "WizTree",
            "manifests": [
                {
                    "download_url": f"https://www.diskanalyzer.com/files/wiztree_{version}_portable.zip",
                    "download_checksum": "f6b71fc54a9bb3f277efdf8afcd45df8ddc1759533f3236437309dae7778b168",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "wiztree64.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "e2157dc64629a29e1713a845e5a9e7cab89d79a7390820c1bfda05c7de989c3d",
                        }
                    ],
                    "add_to_devenv_script": [],
                }
            ],
        })

    # --------------------------------------------------------------------------

    if is_windows:
        version = "1.62.2"
        result.append({
            "label": "RClone",
            "manifests": [
                {
                    "download_url": f"https://github.com/rclone/rclone/releases/download/v{version}/rclone-v{version}-windows-amd64.zip",
                    "download_checksum": "85c623d7808f9d2cf51945e02e98d02b94f9f32ea892237f9a58b544c7a4f4f9",
                    "version": version,
                    "unzip_method": 'default',
                    "executables": [
                        {
                            "path": "rclone.exe",
                            "symlink": [],
                            "add_to_devenv_path": False,
                            "checksum": "b75516a7ff3096b2a15c5897779a75e625f7539d6a333f359ec8b17a18d01340",
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

    version              = "0.4.29"
    download_url         = ""
    download_checksum    = ""
    exe_path             = ""
    checksum             = ""

    if is_windows:
        download_url      = f"https://cancel.fm/dl/Ripcord_Win_{version}.zip"
        download_checksum = "c7a393ac669d02c16828706521833df06b690554368049545e47a1420fa8f04f"
        checksum          = "12d62abb9ad4db43c2b9b1398acae66857eb6e64205364631a3d3bda0ff17e2e"
        exe_path          = "ripcord.exe"
    else:
        exe_path          = f"Ripcord-{version}-x86_64.AppImage"
        download_url      = f"https://cancel.fm/dl/{exe_path}"
        download_checksum = "e320cb3c4043b0f296b4bc1da664b29776f95c2c0b02bdbf115b4d46b1669899"
        checksum          = download_checksum

    result.append({
        "label": "Ripcord",
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
                            "path": "sharex.exe",
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

    version           = "2023.01.06"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""

    if is_windows:
        download_url         = f"https://github.com/yt-dlp/yt-dlp/releases/download/{version}/yt-dlp.exe"
        download_checksum    = "2ff706a386a6890d4fd6871609e99248402959b149781feaeb41fede1c5efea1"
        checksum             = download_checksum
        exe_path             = "yt-dlp.exe"
    else:
        download_url      = f"https://github.com/yt-dlp/yt-dlp/releases/download/{version}/yt-dlp_linux"
        download_checksum = "3b2d1bd378e08570b0fb5bee000cd6968563c4f47527197a5c57463bae8cb2ac"
        checksum          = download_checksum
        exe_path          = "yt-dlp_linux"

    result.append({
        "label": "yt-dlp",
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

    version           = "2.7.4"
    download_url      = ""
    download_checksum = ""
    exe_path          = ""
    checksum          = ""

    if is_windows:
        download_url      = f"https://github.com/keepassxreboot/keepassxc/releases/download/{version}/KeePassXC-{version}-Win64.zip"
        download_checksum = "2ffb7a3289d008d3cd3ad0efffc3238d10a0ce176217d5e7bc34e1b59bcc644a"
        checksum          = "3102bb194dbc60e9ab4ba6c0024129893c8d845c1acf576aab0c05e607ef47ad"
        exe_path          = "KeePassXC.exe"
    else:
        exe_path          = f"KeePassXC-{version}-x86_64.AppImage"
        download_url      = f"https://github.com/keepassxreboot/keepassxc/releases/download/{version}/{exe_path}"
        download_checksum = "15fdc15f340e84e3b7a25a19bfb8c3b16f1e04685c07e5de1616b7cd6bcdded6"
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
        download_checksum = "abc"
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
