def get_manifest():
    result = []

    # --------------------------------------------------------------------------

    version = "20221119-145034-49b9839f"
    result.append({
        "label": "WezTerm",
        "manifests": [
            {
                "version": version,
                "download_checksum": "7041d2c02d226c0c051cc9f6373d51ac9a2de00025e18582077c76e8ad68abe1",
                "download_url": f"https://github.com/wez/wezterm/releases/download/{version}/WezTerm-windows-{version}.zip",
                "executables": [
                    {
                        "path": "wezterm-gui.exe",
                        "symlink": [],
                        "add_to_devenv_path": True,
                        "checksum": "e3faa247d69a8a966302a2ab4e655b08b79548707db79a7b724cf18cccf5ae35",
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

    version = "3.23.4"
    result[-1]['manifests'].append({
        "download_checksum": "df15113aaab9e5f8cac254e02cf23f70d02407c9bf2983c82a9fe0d35bd20682",
        "download_url": f"https://github.com/Kitware/CMake/releases/download/v{version}/cmake-{version}-windows-x86_64.zip",
        "version": "3.23.4",
        "executables": [
            {
                "path": "bin/cmake.exe",
                "symlink": [],
                "add_to_devenv_path": True,
                "checksum": "426074cd812586551fbab2bde67377113e2085c78c2e9a887748e85b4dc3dda5",
            }
        ],
        "add_to_devenv_script": [],
    })

    version = "3.10.3"
    result[-1]['manifests'].append({
        "download_checksum": "3bd57d1cfcf720a4cc72db77bda4c76a7b700fb0341821ad868963ad28856cd0",
        "download_url": f"https://github.com/Kitware/CMake/releases/download/v{version}/cmake-{version}-win64-x64.zip",
        "version": version,
        "executables": [
            {
                "path": "bin/cmake.exe",
                "symlink": [],
                "add_to_devenv_path": False,
                "checksum": "f2e3b486d87d2a6bc19b3a62c740028f3f8945875196ac7d3d0e69649e98730a",
            }
        ],
        "add_to_devenv_script": [],
    })

    # --------------------------------------------------------------------------

    version = "1.9.4"
    result.append({
        "label": "Doxygen",
        "manifests": [
            {
                "download_checksum": "3b34098c5fb016baa1d29aba101fe9d6843213b966b92a6b12c8856c547ee0c4",
                "download_url": f"https://github.com/doxygen/doxygen/releases/download/Release_{version.replace('.', '_')}/doxygen-{version}.windows.x64.bin.zip",
                "version": version,
                "executables": [
                    {
                        "path": "doxygen.exe",
                        "symlink": [f"doxygen-{version}.exe"],
                        "add_to_devenv_path": True,
                        "checksum": "3cb4d89f2b3db7eec2b6797dc6b49cdfe9adda954575898895260f66f312d730",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "2.39.1"
    label = "Git"
    result.append({
        "label": f"{label}",
        "manifests": [
            {
                "download_checksum": "b898306a44084b5fa13b9a52e06408d97234389d07ae41d9409bdf58cad3d227",
                "download_url": f"https://github.com/git-for-windows/git/releases/download/v{version}.windows.1/PortableGit-{version}-64-bit.7z.exe",
                "version": version,
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

    version = "15.0.7"
    result[-1]['manifests'].append({
        "download_checksum": "5428cb72acf63ce3bc4328e546a36674c9736ec040ecc176d362201c6548e6a8",
        "download_url": f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/LLVM-{version}-win64.exe",
        "version": version,
        "executables": [
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
            },
        ],
        "add_to_devenv_script": [],
    })

    version = "14.0.6"
    result[-1]['manifests'].append({
        "download_checksum": "e8dbb2f7de8e37915273d65c1c2f2d96844b96bb8e8035f62c5182475e80b9fc",
        "download_url": f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/LLVM-{version}-win64.exe",
        "version": version,
        "executables": [
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
            },
        ],
        "add_to_devenv_script": [],
    })

    version = "13.0.1"
    result[-1]['manifests'].append({
        "download_checksum": "9d15be034d52ec57cfc97615634099604d88a54761649498daa7405983a7e12f",
        "download_url": f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/LLVM-{version}-win64.exe",
        "version": version,
        "executables": [
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
            },
        ],
        "add_to_devenv_script": [],
    })

    version = "12.0.1"
    result[-1]['manifests'].append({
        "download_checksum": "fcbabc9a170208bb344f7bba8366cca57ff103d72a316781bbb77d634b9e9433",
        "download_url": f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/LLVM-{version}-win64.exe",
        "version": version,
        "executables": [
            {
                "path": f"bin/clang++.exe",
                "checksum": "9f0748de7f946c210a030452de226986bab46a0121d7236ea0e7b5079cb6dfef",
                "symlink": [f"clang++-{version}.exe"],
                "add_to_devenv_path": False,
            },
            {
                "path": f"bin/clang.exe",
                "checksum": "9f0748de7f946c210a030452de226986bab46a0121d7236ea0e7b5079cb6dfef",
                "symlink": [f"clang-{version}.exe"],
                "add_to_devenv_path": False,
            },
        ],
        "add_to_devenv_script": [],
    })

    version = "11.1.0"
    result[-1]['manifests'].append({
        "download_checksum": "b5770bbfac712d273938cd155e232afaa85c2e8d865c7ca504a104a838568516",
        "download_url": f"https://github.com/llvm/llvm-project/releases/download/llvmorg-{version}/LLVM-{version}-win64.exe",
        "version": version,
        "executables": [
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
            },
        ],
        "add_to_devenv_script": [],
    })

    # --------------------------------------------------------------------------

    version = "1.11.1"
    result.append({
        "label": "Ninja",
        "manifests": [
            {
                "download_url": f"https://github.com/ninja-build/ninja/releases/download/v{version}/ninja-win.zip",
                "download_checksum": "524b344a1a9a55005eaf868d991e090ab8ce07fa109f1820d40e74642e289abc",
                "version": version,
                "executables": [
                    {
                        "path": "ninja.exe",
                        "symlink": [],
                        "add_to_devenv_path": True,
                        "checksum": "23e7d60c17b3fcd42d9c00d49eca3c3771b04d7ccb13e49836b06b34e20211c7",
                    }
                ],
                "add_to_devenv_script": [],
             }
        ],
    })

    # --------------------------------------------------------------------------

    version = "16.19.0"
    result.append({
        "label": "NodeJS",
        "manifests": [
            {
                "download_checksum": "e07399a4a441091ca0a5506faf7a9236ea1675220146daeea3bee828c2cbda3f",
                "download_url": f"https://nodejs.org/dist/v{version}/node-v{version}-win-x64.7z",
                "version": version,
                "executables": [
                    {
                        "path": "node.exe",
                        "symlink": [f"node-{version}.exe"],
                        "add_to_devenv_path": True,
                        "checksum": "e4e7f389fbec9300275defc749246c62bdbe4f66406eb01e7c9a4101e07352da",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    date = "20230116"
    version = f"3.10.9+{date}"
    label = "Python"
    result.append({
        "label": f"{label}",
        "manifests": [
            {
                "download_checksum": "4cfa6299a78a3959102c461d126e4869616f0a49c60b44220c000fc9aecddd78",
                "download_url": f"https://github.com/indygreg/python-build-standalone/releases/download/{date}/cpython-{version}-x86_64-pc-windows-msvc-shared-pgo-full.tar.zst",
                "version": version,
                "executables": [
                    {
                        "path": "install/python.exe",
                        "symlink": [],
                        "add_to_devenv_path": True,
                        "checksum": "6dafb845aba67aba898f5aa8adf6c48061e7ffea1d2ed7d290a1e4386e78f2f0",
                    }
                ],
                "add_to_devenv_script": [
                    f"set PYTHONHOME=%~dp0{label}\\{version}\\install",
                    f"set PATH=%~dp0{label}\\{version}\\install\\Script;%PATH%",
                ],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "1.24"
    result.append({
        "label": "Renderdoc",
        "manifests": [
            {
                "download_url": f"https://renderdoc.org/stable/{version}/RenderDoc_{version}_64.zip",
                "download_checksum": "dbd215f7e1c7933b8eedc49499a4372c92e68ddab04af4658f434bfe6c382a9a",
                "version": version,
                "executables": [
                    {
                        "path": "qrenderdoc.exe",
                        "symlink": [],
                        "add_to_devenv_path": False,
                        "checksum": "cfb96468355a416568faf89db18cd8a195bccec87ea16b3fffd3cc13c952c5fd",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "0.6.1"
    result.append({
        "label": "Zeal",
        "manifests": [
            {
                "download_url": f"https://github.com/zealdocs/zeal/releases/download/v{version}/zeal-portable-{version}-windows-x64.7z",
                "download_checksum": "08e9992f620ba0a5ea348471d8ac9c85059e95eedd950118928be639746e3f94",
                "version": version,
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

    version = "0.10.1"
    result.append({
        "label": "Zig",
        "manifests": [
            {
                "download_url": f"https://ziglang.org/download/{version}/zig-windows-x86_64-{version}.zip",
                "download_checksum": "5768004e5e274c7969c3892e891596e51c5df2b422d798865471e05049988125",
                "version": version,
                "executables": [
                    {
                        "path": "zig.exe",
                        "symlink": [f"zig-{version}.exe"],
                        "add_to_devenv_path": True,
                        "checksum": "607c9928a24f9d2e08df1ee240ebfd15ab1eb3c14b85e02f7dad6f8c8b53fea8",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version  = "1.4.13"
    git_hash = "0066c6"
    result.append({
        "label": "Clink",
        "manifests": [
            {
                "download_url": f"https://github.com/chrisant996/clink/releases/download/v{version}/clink.{version}.{git_hash}.zip",
                "download_checksum": "800f7657d73a00dad40d46c9317bd418172ee40cc8b3958e32fba1f0b596e829",
                "version": version,
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

    version = "1.11.1"
    result.append({
        "label": "Dependencies",
        "manifests": [
            {
                "download_url": f"https://github.com/lucasg/Dependencies/releases/download/v{version}/Dependencies_x64_Release.zip",
                "download_checksum": "7d22dc00f1c09fd4415d48ad74d1cf801893e83b9a39944b0fce6dea7ceaea99",
                "version": version,
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

    version = "1.4.1.1022"
    result.append({
        "label": "Everything",
        "manifests": [
            {
                "download_url": f"https://www.voidtools.com/Everything-{version}.x64.zip",
                "download_checksum": "c718bcd73d341e64c8cb47e97eb0c45d010fdcc45c2488d4a3a3c51acc775889",
                "version": version,
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

    version = "0.37.0"
    result.append({
        "label": "FZF",
        "manifests": [
            {
                "download_url": f"https://github.com/junegunn/fzf/releases/download/{version}/fzf-{version}-windows_amd64.zip",
                "download_checksum": "247bffe84ff3294a8c0a7bb96329d5e4152d3d034e13dec59dcc97d8a828000d",
                "version": version,
                "executables": [
                    {
                        "path": "fzf.exe",
                        "symlink": ["fzf.exe"],
                        "add_to_devenv_path": False,
                        "checksum": "c0f4b20d0602977ff3e592cac8eadf86473abed0d24e2def81239bd2e76047e8",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "1.1.42"
    result.append({
        "label": "JPEGView",
        "manifests": [
            {
                "download_url": f"https://github.com/sylikc/jpegview/releases/download/v{version}/JPEGView_{version}.7z",
                "download_checksum": "84b20a6f3ee5184176e46a6755a57147aba90984c2fbbee094e57af036859daf",
                "version": version,
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

    version = "22.02"
    result.append({
        "label": "MPC-Qt",
        "manifests": [
            {
                "download_url": f"https://github.com/mpc-qt/mpc-qt/releases/download/v{version}/mpc-qt-win-x64-{version.replace('.', '')}.zip",
                "download_checksum": "2230c4f4de1a429ccc67e5c590efc0a86fbaffeb33a4dc5f391aa45e660b80c2",
                "version": version,
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

    version = "0.8.2"
    result.append({
        "label": "NVim",
        "manifests": [
            {
                "download_url": f"https://github.com/neovim/neovim/releases/download/v{version}/nvim-win64.zip",
                "download_checksum": "e2d53c6fd4a3caefbff47765d63d1640a5a134de46623ed8e3f9bf547791c26f",
                "version": version,
                "executables": [
                    {
                        "path": "bin/nvim.exe",
                        "symlink": [],
                        "add_to_devenv_path": True,
                        "checksum": "dd8b045e9a76bea6add3e7a727387aef6996846907e061df07971329b9464faf",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "0.10.3"
    result.append({
        "label": "Neovide",
        "manifests": [
            {
                "download_url": f"https://github.com/neovide/neovide/releases/download/{version}/neovide-windows.zip",
                "download_checksum": "ec54f811e5cb271102751694124380f4a58ae5edf99a1a267e8b070a362f8297",
                "version": version,
                "executables": [
                    {
                        "path": "neovide.exe",
                        "symlink": ["neovide.exe"],
                        "add_to_devenv_path": False,
                        "checksum": "2c1df8ec7287f927554ebd9ad5cd0da34d7e72c3384fe266080ddf612adf6e5a",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "1.26.2"
    result.append({
        "label": "ImHex",
        "manifests": [
            {
                "download_url": f"https://github.com/WerWolv/ImHex/releases/download/v{version}/imhex-{version}-Windows-Portable.zip",
                "download_checksum": "4f58097c3ccee88d8dff0d48da0f239af8a9d444903cc19a3369f63caa8d77e6",
                "version": f"{version}",
                "executables": [
                    {
                        "path": "imhex.exe",
                        "symlink": [],
                        "add_to_devenv_path": False,
                        "checksum": "ddd448c0d8fe71295bbcc5b52c9e9f4b06956a79572b7d634436a49728f5f341",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "22.3"
    result.append({
        "label": "MobaXTerm",
        "manifests": [
            {
                "download_url": f"https://download.mobatek.net/2232022120824733/MobaXterm_Portable_v{version}.zip",
                "download_checksum": "c8de508d6731f31a73f061e58942691466d1d24cfa941e642e16e0930be2fad9",
                "version": version,
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

    version = "3.0.5847"
    result.append({
        "label": "SystemInformer",
        "manifests": [
            {
                "download_url": f"https://github.com/winsiderss/si-builds/releases/download/{version}/systeminformer-{version}-bin.zip",
                "download_checksum": "4557e58f698048e882515faac89c9c7f654247dbf4bd656ceed5c3f97afef77d",
                "version": "3.0.5847",
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

    version = "13.0.0"
    result.append({
        "label": "Ripgrep",
        "manifests": [
            {
                "download_url": f"https://github.com/BurntSushi/ripgrep/releases/download/{version}/ripgrep-{version}-x86_64-pc-windows-msvc.zip",
                "download_checksum": "a47ace6f654c5ffa236792fc3ee3fefd9c7e88e026928b44da801acb72124aa8",
                "version": version,
                "executables": [
                    {
                        "path": "rg.exe",
                        "symlink": ["rg.exe"],
                        "add_to_devenv_path": False,
                        "checksum": "ab5595a4f7a6b918cece0e7e22ebc883ead6163948571419a1dd5cd3c7f37972",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "2.0.0"
    result.append({
        "label": "Sioyek",
        "manifests": [
            {
                "download_url": f"https://github.com/ahrm/sioyek/releases/download/v{version}/sioyek-release-windows-portable.zip",
                "download_checksum": "1f4fedbb38c0dc46bbba4bb95d0d6fab39fcf3525092ac26d92c891684d2bf8d",
                "version": version,
                "executables": [
                    {
                        "path": "sioyek.exe",
                        "symlink": [],
                        "add_to_devenv_path": False,
                        "checksum": "6c660f0f7265fabe6d943d15d9b5c7e85f2dbcf7fecb7d2cd0639e7086b1c034",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "8.6.0"
    result.append({
        "label": "Fd",
        "manifests": [
            {
                "download_url": f"https://github.com/sharkdp/fd/releases/download/v{version}/fd-v{version}-x86_64-pc-windows-msvc.zip",
                "download_checksum": "9cff97eb1c024ed94cc76a4b2d924ab3df04b37e7430c282b8188a13f1653ebe",
                "version": version,
                "executables": [
                    {
                        "path": "fd.exe",
                        "symlink": ["fd.exe"],
                        "add_to_devenv_path": False,
                        "checksum": "a93ab08528896556ba3a6c262c8d73b275df2ce7a4138f5323f3eff414403f33",
                    }
                ],
                "add_to_devenv_script": [
                    "set FZF_DEFAULT_OPTS=--multi --layout=reverse",
                    "set FZF_DEFAULT_COMMAND=fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude .cache --exclude .vs",
                ],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "4_12"
    result.append({
        "label": "WizTree",
        "manifests": [
            {
                "download_url": f"https://www.diskanalyzer.com/files/wiztree_{version}_portable.zip",
                "download_checksum": "f6b71fc54a9bb3f277efdf8afcd45df8ddc1759533f3236437309dae7778b168",
                "version": version,
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

    version = "1.61.1"
    result.append({
        "label": "RClone",
        "manifests": [
            {
                "download_url": f"https://github.com/rclone/rclone/releases/download/v{version}/rclone-v{version}-windows-amd64.zip",
                "download_checksum": "99daaa95867cdf0758ec1d5d7f2ebdb3bf74c8c8602e2aaf888e637163d2ebdd",
                "version": version,
                "executables": [
                    {
                        "path": "rclone.exe",
                        "symlink": [],
                        "add_to_devenv_path": False,
                        "checksum": "e94901809ff7cc5168c1e857d4ac9cbb339ca1f6e21dcce95dfb8e28df799961",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "1.5.3"
    result.append({
        "label": "Eyes-Thanks",
        "manifests": [
            {
                "download_url": f"https://github.com/yalov/eyes-thanks/releases/download/{version}/EyesThanks_v{version}.zip",
                "download_checksum": "6ab2b20730f56aa54263eb942be8849f52f9cba26438aee3c1b01103069411cc",
                "version": version,
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

    version = "0.4.29"
    result.append({
        "label": "Ripcord",
        "manifests": [
            {
                "download_url": f"https://cancel.fm/dl/Ripcord_Win_{version}.zip",
                "download_checksum": "c7a393ac669d02c16828706521833df06b690554368049545e47a1420fa8f04f",
                "version": version,
                "executables": [
                    {
                        "path": "ripcord.exe",
                        "symlink": [],
                        "add_to_devenv_path": False,
                        "checksum": "12d62abb9ad4db43c2b9b1398acae66857eb6e64205364631a3d3bda0ff17e2e",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    version = "15.0.0"
    result.append({
        "label": "ShareX",
        "manifests": [
            {
                "download_url": f"https://github.com/ShareX/ShareX/releases/download/v{version}/ShareX-{version}-portable.zip",
                "download_checksum": "c3bc97e9fb8d107e92cb494b50f842fccafbc9fd810588a1b635aee4dbe90bc1",
                "version": version,
                "executables": [
                    {
                        "path": "sharex.exe",
                        "symlink": [],
                        "add_to_devenv_path": False,
                        "checksum": "none",
                    }
                ],
                "add_to_devenv_script": [],
            }
        ],
    })

    # --------------------------------------------------------------------------

    return result
