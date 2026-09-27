# SDDM OVERDOSE

糖糖的主题！

✟升天✟

# 为什么音效没了

执行如下命令即可修复：

```bash
sudo machinectl shell sddm@ /bin/bash
systemctl --user --now enable pipewire.socket pipewire.service wireplumber.service
exit
```

这是因为`sddm`用户的音频服务没有正确配置。