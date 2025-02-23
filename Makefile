CONFIG_DIR = config
SRCS = $(shell find $(CONFIG_DIR) -type f)
TARGET = ../zmk/app/build/zephyr/zmk.uf2

.PHONY: build clean pristine

# 通常のビルド（キャッシュを使う）
build: $(TARGET)

$(TARGET): $(SRCS)
	docker exec -w /workspaces/zmk/app -it $(container_name) west build -b seeeduino_xiao_ble -- -DSHIELD=nape -DZMK_CONFIG="/workspaces/zmk-config/config"
#	docker exec -w /workspaces/zmk/app -it $(container_name) \
	west build -b seeeduino_xiao_ble -S studio-rpc-usb-uart \
	-- -DSHIELD=nape -DZMK_CONFIG="/workspaces/zmk-config/config" \
	-DCONFIG_ZMK_STUDIO=n -DCONFIG_ZMK_STUDIO_LOCKING=n



# ビルドキャッシュの完全削除 + 再ビルド
pristine:
	docker exec -w /workspaces/zmk/app -it $(container_name) \
	west build -b seeeduino_xiao_ble -t pristine
#	make build

# ビルドフォルダを手動で削除
clean:
	docker exec -it $(container_name) rm -rf /workspaces/zmk/app/build
