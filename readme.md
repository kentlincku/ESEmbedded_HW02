HW02 範例
===
## 1. 實驗題目
使用並觀察pop與push指令
## 2. 實驗步驟
1. 先將資料夾 gnu-mcu-eclipse-qemu 完整複製到 ESEmbedded_HW02 資料夾中

2. 設計測試程式 main.s ，在初始 register 後將 register 的值 push 到 sp 再 pop 到其他 register, 觀察過程變化

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

3. 將 main.s 編譯並以 qemu 模擬， `$ make clean`, `$ make`, `$ make qemu`
開啟另一 Terminal 連線 `$ arm-none-eabi-gdb` ，再輸入 `target remote localhost:1234` 連接，輸入兩次的 `ctrl + x` 再輸入 `2`, 開啟 Register 以及指令，並且輸入 `si` 單步執行觀察。

前幾步驟先將register初始，當執行 `push {r1, r2, r3}` 後，觀察 `0x200000fc` 、 `0x200000f8` 、 `0x200000f4` 可以發現分別對應 `r3`, `r2` 和 `r1`

![](https://github.com/kentlincku/ESEmbedded_HW02/blob/master/push-1.png)

在執行 `pop {r4, r5, r6}` 之後， `r4`, `r5`, `r6` 分別對應 `r1`, `r2` 和 `r3`

![](https://github.com/kentlincku/ESEmbedded_HW02/blob/master/pop.png)

最後，為驗證`str`與`ldr`能否取代`pop`與`push`，發現除了`sp`不會改變以外，基本上是可以用的

![](https://github.com/kentlincku/ESEmbedded_HW02/blob/master/strldr.png)

## 3. 結果與討論
從 `push {r1, r2, r3}` 執行後的結果可以看出可以改寫為
```
push {r1}
push {r2}
push {r3}
```
而 `pop {r4, r5, r6}` 則是可以改寫為
```
pop {r4}
pop {r5}
pop {r6}
```
記憶體位置中則採先進先出， `0x200000f4` 的位置先移出，接下來才是 `0x200000f8` 和 `0x200000fc`
