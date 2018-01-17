#include "kernel.h"

void kernel(void) {
    clock_init();
    systick_init();
    heap_init();
    dht_init();
    led_init();
    terminal_init();
    esp_init();
    peons_init();
    {
        //! create terminal thread
        peon_create(TASK_PTR(terminal_start));
        //! create dht thread
        peon_create(TASK_PTR(dht_task));
        //! create led blink thread
        peon_create(TASK_PTR(led_loop));
        //! create log monitor thread
        peon_create(TASK_PTR(log_task));
    }
    //! enter the user mode
    sv_call(SVC_USER_MODE);
}
