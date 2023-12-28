#include <main.h>
#include <pthread.h>

int main()
{
    screen_config();
    init_screen_x = screen_x + screen_y;
    init_screen_y = screen_y + screen_x;
    if (!init_egl(init_screen_x, init_screen_y))
    {
        exit(0);
    }
    pthread_t tid_ESP;
    EESP *a = new EESP;
    pthread_create(&tid_ESP, NULL, ESP_Op, (void *)a);
    Touch_Init(screen_x, screen_y);
    ImGui_init();
    Init_touch_config();
    for (;;)
    {
        tick(a);
    }
    pthread_exit(NULL);
    shutdown();
    return 0;
}
