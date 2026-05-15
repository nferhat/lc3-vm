# `lc3-vm` - a VM for the Little-Computer 3

This VM is for the Little-Computer 3 architecture, a simplistic architecture used for educational purposes.

The goal of this project is to try out the [Hare programming language](https://harelang.org) in a real project that's actually feasable, to which I can say the language is extremely pleasant, simple and straightforward. I enjoyed writing this project in ~3 hours, while learning about it.

## Build instructions

Since hare only supports Linux as of right now, you can only run it on Linux systems.

Included are some little games from [Justin Meiners](https://www.jmeiners.com/) and [Ryan Pendleton](https://www.ryanp.me/), which I have used to test these. You can also use `lc3tools` (as of right now) in order to compile test programs.

```sh
make lc3
./build/lc3 ./test/2048.obj
```

Here's an example test program

```asm
.ORIG x3000
    lea R0, hello
    puts
    halt

; data region
hello: .stringz "Hello, world\n"

.END
```

## References

- <https://www.jmeiners.com/lc3-vm/>
- <https://highered.mheducation.com/sites/0072467509/> 
- <https://www.jmeiners.com/lc3-vm/supplies/lc3-ref-card.png>
