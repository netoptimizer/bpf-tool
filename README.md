# BPF userspace tool

## Examples

The tool allows listing programs and maps on the system as well as simple
dumping and modification of the maps.

```
# bpf map show
   10: hash  key:4B  value:8B  max_entries:2048  flags:0x0

# bpf prog show
   10: xdp  tag: 00:5a:3d:21:23:62:0c:8b  jited: 0/0B  xlated: 0/560B

# bpf map lookup id 10 key 0 1 2 3
key:
00 01 02 03
value:
00 01 02 03 04 05 06 07

# bpf map dump id 10
key:
00 01 02 03
value:
00 01 02 03 04 05 06 07

key:
0d 00 07 00
value:
03 00 00 00 00 00 00 00

Found 2 elements

# bpf map del id 10 key 13 00 07 00

# bpf map lookup id 10 key 13 00 07 00
key:
0d 00 07 00

Not found
```

Example with kernel's samples/bpf/xdp1 running:
```
# bpf map lookup id 11 key 6 0 0 0
key:
06 00 00 00
value (CPU 00): 00 00 00 00 00 00 00 00
value (CPU 01): 00 00 00 00 00 00 00 00
value (CPU 02): 00 00 00 00 00 00 00 00
value (CPU 03): 23 0b 06 00 00 00 00 00
value (CPU 04): 00 00 00 00 00 00 00 00
value (CPU 05): 23 0b 06 00 00 00 00 00
value (CPU 06): 00 00 00 00 00 00 00 00
value (CPU 07): 10 d0 00 00 00 00 00 00
value (CPU 08): 00 00 00 00 00 00 00 00
value (CPU 09): 16 d0 00 00 00 00 00 00
value (CPU 10): 00 00 00 00 00 00 00 00
value (CPU 11): 0b 3b 05 00 00 00 00 00
value (CPU 12): 00 00 00 00 00 00 00 00
value (CPU 13): 36 46 0b 00 00 00 00 00
value (CPU 14): 00 00 00 00 00 00 00 00
value (CPU 15): 27 0b 06 00 00 00 00 00
value (CPU 16): 00 00 00 00 00 00 00 00
value (CPU 17): 20 0b 06 00 00 00 00 00
value (CPU 18): 00 00 00 00 00 00 00 00
value (CPU 19): 26 0b 06 00 00 00 00 00


```

## Building

The tool depends on kernel's libbpf being installed in standard location.
Moreover, you need to install the bpf.h header.  Here is a kernel patch
modifying libbpf's makefile:

```diff
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 1f5300e56b44..9e658ffe31de 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -46,6 +46,7 @@ else
 endif
 
 prefix ?= /usr/local
+headerdir = $(prefix)/include/libbpf/
 libdir = $(prefix)/$(libdir_relative)
 man_dir = $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
@@ -90,11 +91,13 @@ endif
 export prefix libdir src obj
 
 # Shell quotes
+headerdir_SQ = $(subst ','\'',$(headerdir))
 libdir_SQ = $(subst ','\'',$(libdir))
 libdir_relative_SQ = $(subst ','\'',$(libdir_relative))
 plugin_dir_SQ = $(subst ','\'',$(plugin_dir))
 
 LIB_FILE = libbpf.a libbpf.so
+HEADER_FILE = bpf.h
 
 VERSION                = $(BPF_VERSION)
 PATCHLEVEL     = $(BPF_PATCHLEVEL)
@@ -189,7 +192,11 @@ install_lib: all_cmd
        $(call QUIET_INSTALL, $(LIB_FILE)) \
                $(call do_install,$(LIB_FILE),$(libdir_SQ))
 
-install: install_lib
+install_hdr: all_cmd
+       $(call QUIET_INSTALL, $(HEADER_FILE)) \
+               $(call do_install,$(HEADER_FILE),$(headerdir_SQ))
+
+install: install_lib install_hdr
 
 ### Cleaning rules
 
```

