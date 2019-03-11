HW02 範例
===
## 1. 實驗題目
使用並觀察pop與push指令
## 2. 實驗步驟
1. 先將資料夾 gnu-mcu-eclipse-qemu 完整複製到 ESEmbedded_HW02 資料夾中

2. 設計測試程式 main.s ，在初始 register 後將 register 的值 push 到 sp 再 pop 到其他 register, 觀察過程變化
main.s:
```assembly


3. 設計測試程式 main.s ，從 _start 開始後依序執行 b 以及 bl 並且觀察其指令差異，
目標比較 14 行的 `b	label01` 以及 22 行的 `bl	sleep` 執行時的變化。


main.s:

```assembly
_start:
	mov r0, sp
	mov r1, #1
	mov r2, #2
	mov r3, #3
	mov r4, #0
	mov r5, #0
	mov r6, #0
	push {r1, r2, r3}
	pop {r4, r5, r6}
	mov r4, #0
	mov r5, #0
	mov r6, #0
	str r1, [r0, #-4]
	str r2, [r0, #-8]
	str r3, [r0, #-12]
	ldr r4, [r0, #-4]
	ldr r5, [r0, #-8]
	ldr r6, [r0, #-12]
sleep:
	b	sleep	.
```

4. 將 main.s 編譯並以 qemu 模擬， `$ make clean`, `$ make`, `$ make qemu`
開啟另一 Terminal 連線 `$ arm-none-eabi-gdb` ，再輸入 `target remote localhost:1234` 連接，輸入兩次的 `ctrl + x` 再輸入 `2`, 開啟 Register 以及指令，並且輸入 `si` 單步執行觀察。
當執行到 `0xa` 的 `b.n    0xc ` 時， `pc` 跳轉至 `0x0c` ，除了 branch 外並無變化。

![](https://github.com/vwxyzjimmy/ESEmbedded_HW02/blob/master/img-folder/0x0a.jpg)

當執行到 `0x0e` 的 `bl     0x12` 後，會發現 `lr`  更新為 `0x13`。

![](https://github.com/vwxyzjimmy/ESEmbedded_HW02/blob/master/img-folder/0x12.jpg)

## 3. 結果與討論
1. 使用 `bl` 時會儲存 `pc` 下一行指令的位置到 `lr` 中，通常用來進行副程式的呼叫，副程式結束要返回主程式時，可以執行 `bx lr`，返回進入副程式前下一行指令的位置。
2. 根據 [Cortex-M4-Arm Developer](https://developer.arm.com/products/processors/cortex-m/cortex-m4)，由於 Cortex-M4 只支援 Thumb/ Thumb-2 指令，使用 `bl` 時，linker 自動把 pc 下一行指令位置並且設定 LSB 寫入 `lr` ，未來使用 `bx lr` 等指令時，由於 `lr` 的 LSB 為 1 ，能確保是在 Thumb/ Thumb-2 指令下執行後續指令。
以上述程式為例， `bl     0x12` 下一行指令位置為  0x12 並設定 LSB 為 1 ，所以寫入 0x13 至 `lr` 。
