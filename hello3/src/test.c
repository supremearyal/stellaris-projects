#define BB_RCGCGPIO_PORTF    *((volatile unsigned int *) 0x43FCC114)
#define BB_PORT_F_PIN_1_DIR  *((volatile unsigned int *) 0x424A8004)
#define BB_PORT_F_PIN_1_DEN  *((volatile unsigned int *) 0x424AA384)
#define BB_PORT_F_PIN_1_DATA *((volatile unsigned int *) 0x424A7f84)

#define PERIPHERAL_BASE 0xE000E000

/*
Max delay routine using systick

#define STCTRL          *((volatile unsigned int *) (PERIPHERAL_BASE + 0x010))
#define ST_COUNT        (1 << 16)
#define ST_CLKSRC       (1 << 2)
#define ST_INTEN        (1 << 1)
#define ST_ENABLE       (1 << 0)
#define STRELOAD        *((volatile unsigned int *) (PERIPHERAL_BASE + 0x014))
#define STCURRENT       *((volatile unsigned int *) (PERIPHERAL_BASE + 0x018))

void delay_max_systick(void)
{
    STRELOAD = 0xffffff;
    STCTRL |= ST_ENABLE | ST_CLKSRC;

    while (!(STCTRL & ST_COUNT))
        ;

    STCTRL &= ~ST_ENABLE;
}
*/

#define nop() __asm__("nop")

#define TIMER_BASE 0x400FE000
#define GPT_BASE   0x40030000

#define RCGCWTIMER *((volatile unsigned int *) (TIMER_BASE + 0x65C))
#define GPTMCTL    *((volatile unsigned int *) (GPT_BASE + 0x00C))
#define GPTMCFG    *((volatile unsigned int *) (GPT_BASE + 0x000))
#define GPTMTAMR   *((volatile unsigned int *) (GPT_BASE + 0x004))
#define GPTMTAILR  *((volatile unsigned int *) (GPT_BASE + 0x028))
#define GPTMRIS    *((volatile unsigned int *) (GPT_BASE + 0x01C))
#define GPTMICR    *((volatile unsigned int *) (GPT_BASE + 0x024))

#define TIMER_R0 (1 << 0)
#define GPT_ONESHOT (0x1 << 0)
#define GPT_TAEN (1 << 0)
#define GPT_TATORIS (1 << 0)
#define GPT_TATOCINT (1 << 0)

// TODO: Generalize to clock frequency.
// Assume 16 MHz for now.
void delay_ms(int ms)
{
    RCGCWTIMER |= TIMER_R0;

    GPTMCTL &= ~GPT_TAEN;
    GPTMCFG = 0;
    GPTMTAMR |= GPT_ONESHOT;
    GPTMTAILR = 16000000;
    GPTMCTL |= GPT_TAEN;

    while (!(GPTMRIS & GPT_TATORIS))
        ;

    GPTMICR |= GPT_TATOCINT;
}

int main(void)
{
    // Set clock to 80 Mhz.
    *((unsigned int *) 0x400FE070) = 0xC1000010;
    
    // Enable the clock for port F.  Also, we need to wait at least 3
    // cycles. Due to pipelining, this may be less than 3 cycles, but
    // the next statement isn't executed so we should be good. In this
    // particular case, a single nop is enough but I wanted to kind of
    // match the documentation. There doesn't seem to be a way to be
    // 100% sure about instruction cycles.  See:
    // http://www.pabigot.com/arm-cortex-m/the-effect-of-the-arm-cortex-m-nop-instruction/
    BB_RCGCGPIO_PORTF = 1;
    nop();
    nop();
    nop();

    // Enable port F pin 1 direction to output.
    BB_PORT_F_PIN_1_DIR = 1;

    // Enable the digital feature of port F pin 1.
    BB_PORT_F_PIN_1_DEN = 1;
    
    while (1) {
        // Toggle pin
        BB_PORT_F_PIN_1_DATA = 1;
        delay_ms(500);
        BB_PORT_F_PIN_1_DATA = 0;
        delay_ms(500);
    }

    return 0;
}
