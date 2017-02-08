cd ..
patch -p1 < avct_patch/enable_root_user.patch
patch -p1 < avct_patch/enable_telnet.patch
patch -p1 < avct_patch/alias.patch
patch -p1 < avct_patch/mcp.patch

