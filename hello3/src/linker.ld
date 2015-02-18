MEMORY
{
    ram (rwx) : ORIGIN = 0x20000000, LENGTH = 32K
    rom (rw)  : ORIGIN = 0x00000000, LENGTH = 256K
}

SECTIONS
{
    .text :
    {
        * (.vector)
        * (.init)
        * (.text)
        * (.rodata)
        _etext = .;
    } > rom

    .data :
    {
        _bdata = .;
        * (.data)
        _edata = .;
    } > ram AT > rom
    
    .bss :
    {
        _bbss = .;
        * (.bss)
        _ebss = .;
    } > ram
}
