# Makefile 参考

## gcc 编译流程

> 预处理(Pre-Processing) -> 编译(Compling) -> 汇编(Assembling) -> 连接(Linking)

1. 预处理：处理 #include、#define、#ifdef 等宏命令
2. 编译：把预处理完的文件编译为汇编程序 .s
3. 汇编：把汇编程序 .s 编译为 .o 二进制文件
4. 链接：把多个二进制文件 .o 集合（链接）成一个可执行文件

> 由此可见，多头文件 .h 时，在预处理阶段处理，指明头文件所在地址，但通常在 makefile 中是一个命令完成到第3步，生成 .o
> 多源文件 .c 时，在链接阶段处理，gcc 命令要写出所有源文件，不然会出现引用了却未定义的函数、变量等

## gcc 常用编译命令

| 选项 |           用法            | 作用                                                         |
| :--: | :-----------------------: | :----------------------------------------------------------- |
|  无  |        `gcc test`         | 将 test.c 预处理、编译、汇编并链接形成可执行文件。(out: a.out) |
| `-o` |   `gcc test.c -o test`    | 将 test.c 预处理、编译、汇编并链接形成可执行文件 test; -o 选项用来指定输出文件的文件名。 |
| `-E` | `gcc -E test.c -o test.i` | 将 test.c 预处理输出 test.i 文件。                           |
| `-c` |      `gcc -c test.s`      | 将汇编输出文件 test.s 编译输出 test.o 文件。                 |
| `-S` |      `gcc -S test.i`      | 将预处理输出文件 test.i 汇编成 test.s 文件。                 |
|  无  |   `gcc test.o -o test`    | 将编译输出文件test.o链接成最终可执行文件test。               |
| `-O` | `gcc -O1 test.c -o test`  | 使用编译优化级别1编译程序。级别为1~3，级别越大优化效果越好，但编译时间越长。 |

## Makefile 的一个例子

项目结构

```sh
> tree
.
├── common
│   ├── abc.c
│   ├── abc.h
│   └── test
│       ├── test.c
│       └── test.h
├── Makefile
└── myhello.c
 
2 directories, 6 files
```

Makefile

```makefile
//目标（要生成的文件名）
TARGET     := myhello
//编译器的选择（在Linux中其实可以忽略，因为cc指向的本来就是gcc）   
CC	   := gcc  
//编译的参数
CFLAG	   := -Wall  
//编译包含的头文件所在目录 
INCLUDES   := -I. -Icommon/ -Icommon/test  
 //所有用到的源文件，注意：非当前目录的要+上详细地址
SRCS    = myhello.c ./common/abc.c ./common/test/test.c 
//把源文件SRCS字符串的后缀.c改为.o 
OBJS    = $(SRCS:.c=.o)  
//匹配所有的伪目标依赖，即执行目标myhello.o & ./common/abc.c & ./common/test/test.c 
.PHONY:all //all为伪目标all:$(OBJS) 
    //当所有依赖目标都存在后，链接，即链接myhello.o & ./common/abc.c & ./commontest/test.c
    $(CC) $(LDFLAG) -o $(TARGET) $^
//重定义隐藏规则，匹配上述目标：myhello.o & ./common/abc.c & ./common/test/test.c
%.o:%.c 
    //生成.o文件，注意，由于SRCS有个别包含详细地址的，生成的.o文件也是详细地址
    $(CC) -c $(INCLUDES) $(CFLAG) $(CPPFLAG) $< -o $@
//清空除源文件外的所有生成文件 
clean:     rm -rf $(basename $(TARGET)) $(SRCS:.c=.o)
```

执行后

```sh
tree
.
├── common
│   ├── abc.c
│   ├── abc.h
│   ├── abc.o
│   └── test
│       ├── test.c
│       ├── test.h
│       └── test.o
├── Makefile
├── myhello
├── myhello.c
└── myhello.o
 
2 directories, 10 files
```

## 参考
[参考文章](https://blog.csdn.net/gmpy_tiger/article/details/50903620)