# yuv.yazi

Yazi plugin for viewing YUV-files

## Install the plugin:

```sh
ya pack -a figgis/yuv
```

Create `~/.config/yazi/yazi.toml` and add:

```toml
[plugin]
  previewers = [
    { name = "*.yuv", run = "yuv" },
  ]
  prepend_preloaders = [
  	{ name = "*.yuv", run = "yuv" },
  ]
```
