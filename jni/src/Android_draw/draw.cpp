#include <draw.h>
#include <touch.h>
#include <Xa.h>
#include <string>

void *handle;
EGLDisplay display = EGL_NO_DISPLAY;
EGLConfig config;
EGLSurface surface = EGL_NO_SURFACE;
NativeWindowType native_window;
NativeWindowType (*createNativeWindow)(const char *surface_name, uint32_t screen_width, uint32_t screen_height);
EGLContext context = EGL_NO_CONTEXT;

Screen full_screen;
int Orientation = 0;
int screen_x = 0, screen_y = 0;
int init_screen_x = 0, init_screen_y = 0;
bool g_Initialized = false;

float matrix[16];

int PlayerCount;

struct hack
{
public:
    bool esp;
    bool box;
    bool line;
    bool people;
    bool name;
    bool distance;
    bool Sid;
    bool U3D;
    bool GG;
};
struct color
{
    ImColor BoxColor = {1.0f, 0.0f, 0.0f, 1.0f};
    ImColor BotColor = ImColor(255, 255, 255, 255);
    ImColor LineColor = ImColor(255, 0, 0, 255);
    ImColor HpColor = ImColor(10, 240, 10, 210);
    ImColor DistanceColor = ImColor(0, 255, 0, 255);
    ImColor RightColor = ImColor(255, 200, 0, 255);
};
hack hack;
color color;

string exec(string command)
{
    char buffer[128];
    string result = "";
    FILE *pipe = popen(command.c_str(), "r");
    if (!pipe)
    {
        return "popen failed!";
    }
    while (!feof(pipe))
    {
        if (fgets(buffer, 128, pipe) != nullptr)
            result += buffer;
    }
    pclose(pipe);
    return result;
}

int init_egl(int _screen_x, int _screen_y, bool log)
{
    display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    if (display == EGL_NO_DISPLAY)
    {
        printf("eglGetDisplay error=%u\n", glGetError());
        return -1;
    }
    if (log)
        printf("eglGetDisplay ok\n");
    EGLint *version = new EGLint[2];
    if (!eglInitialize(display, &version[0], &version[1]))
    {
        printf("eglInitialize error=%u\n", glGetError());
        return -1;
    }
    if (log)
        printf("eglInitialize ok\n");
    const EGLint attribs[] = {EGL_BUFFER_SIZE, 32, EGL_RED_SIZE, 8, EGL_GREEN_SIZE, 8, EGL_BLUE_SIZE, 8, EGL_ALPHA_SIZE, 8, EGL_DEPTH_SIZE, 8, EGL_STENCIL_SIZE, 8, EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT, EGL_SURFACE_TYPE, EGL_WINDOW_BIT, EGL_NONE};
    EGLint num_config;
    if (!eglGetConfigs(display, nullptr, 1, &num_config))
    {
        printf("eglGetConfigs  error =%u\n", glGetError());
        return -1;
    }
    if (log)
        printf("num_config=%d\n", num_config);
    if (!eglChooseConfig(display, attribs, &config, 1, &num_config))
    {
        printf("eglChooseConfig  error=%u\n", glGetError());
        return -1;
    }
    if (log)
        printf("eglChooseConfig ok\n");
    int attrib_list[] = {EGL_CONTEXT_CLIENT_VERSION, 3, EGL_NONE};
    context = eglCreateContext(display, config, EGL_NO_CONTEXT, attrib_list);
    if (context == EGL_NO_CONTEXT)
    {
        printf("eglCreateContext  error = %u\n", glGetError());
        return -1;
    }
    if (log)
        printf("eglCreateContext ok\n");
    void *sy = get_createNativeWindow();
    createNativeWindow = (NativeWindowType(*)(const char *, uint32_t, uint32_t))(sy);
    native_window = createNativeWindow("Ssage", _screen_x, _screen_y);
    surface = eglCreateWindowSurface(display, config, native_window, nullptr);
    if (surface == EGL_NO_SURFACE)
    {
        printf("eglCreateWindowSurface  error = %u\n", glGetError());
        return -1;
    }
    if (log)
        printf("eglCreateWindowSurface ok\n");
    if (!eglMakeCurrent(display, surface, surface, context))
    {
        printf("eglMakeCurrent  error = %u\n", glGetError());
        return -1;
    }
    if (log)
        printf("eglMakeCurrent ok\n");
    return 1;
}

void screen_config()
{
    std::string window_size = exec("wm size");
    if (window_size.size() > 30)
    {
        sscanf(window_size.c_str(), "Override size: %dx%d", &screen_x, &screen_y);
    }
    else
    {
        sscanf(window_size.c_str(), "Physical size: %dx%d", &screen_x, &screen_y);
    };
    full_screen.ScreenX = screen_x;
    full_screen.ScreenY = screen_y;
    std::thread *orithread = new std::thread([&]
                                             {
        while(true){
			string Orientation1 = getmiddle(exec("dumpsys display | grep orientation"),"orientation=",",");
            Orientation = atoi(Orientation1.c_str());
            if(Orientation == 0 || Orientation == 2) {
                screen_x = full_screen.ScreenX;
                screen_y = full_screen.ScreenY;
            }
            if(Orientation == 1 || Orientation == 3) {
                screen_x = full_screen.ScreenY;
                screen_y = full_screen.ScreenX;
            }
            std::this_thread::sleep_for(0.5s);
        } });
    orithread->detach();
}

void shutdown()
{
    if (!g_Initialized)
    {
        return;
    }
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplAndroid_Shutdown();
    ImGui::DestroyContext();
    if (display != EGL_NO_DISPLAY)
    {
        eglMakeCurrent(display, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
        if (context != EGL_NO_CONTEXT)
        {
            eglDestroyContext(display, context);
        }
        if (surface != EGL_NO_SURFACE)
        {
            eglDestroySurface(display, surface);
        }
        eglTerminate(display);
    }
    display = EGL_NO_DISPLAY;
    context = EGL_NO_CONTEXT;
    surface = EGL_NO_SURFACE;
    ANativeWindow_release(native_window);
}

void startesp(EESP *a)
{

    /*
    pid = getProcessID("com.dvloper.thetwins");
    if (pid <= 0)
    {
        std::cout << "请在游戏启动后注入\n";
    };
    a->libbase = getbss(pid, "libunity.so");
    // libunity.so:bss[1] + 0x5CD88 -> 0x1C0 -> 0x34 -> 0xC4
    a->Matrix = getPtr32(getPtr32(getPtr32(a->libbase + 0x5CD88) + 0x1C0) + 0x34) + 0xC4; // 矩阵
    // libunity.so:bss[1] + 0x34D4C -> 0x8 -> 0xFC -> 0x4
    a->MSF = getPtr32(getPtr32(getPtr32(a->libbase + 0x34D4c) + 0x8) + 0xFC) + 0x4;
    a->count = getDword(a->MSF) - 258 + 44;
    // 因为反复读取一样的 所以我处理 优化 了 一下
    */
    float px = screen_x / 2;

    float py = screen_y / 2;
    // 遍历矩阵
    for (int i = 0; i < 16; i++)
    {
        float matrixaddr = getFloat(a->Matrix + i * 4);
        matrix[i] = matrixaddr;
    };
    // 遍历人物信息
    for (int i = 1; i <= a->count; i++)
    {
        long int object = getPtr32(a->MSF + 0x4 * i);
        float d_x = getFloat(object + 0x60);
        float d_z = getFloat(object + 0x60 + 0x4);
        float d_y = getFloat(object + 0x60 + 0x8);

        if ((d_x == 0.0))
            continue;                                                                       //
        float camear_z = matrix[3] * d_x + matrix[7] * d_z + matrix[11] * d_y + matrix[15]; // 相机Z
        int jl = camear_z / 1;
        float camera = camear_z;
        float r_x = px + (matrix[0] * d_x + matrix[4] * d_z + matrix[8] * d_y + matrix[12]) / camear_z * px;         // 视角高
        float r_y = py - (matrix[1] * d_x + matrix[5] * (d_z - 0.3) + matrix[9] * d_y + matrix[13]) / camear_z * py; //;视角宽
        float r_w = py - (matrix[1] * d_x + matrix[5] * (d_z + 1.8) + matrix[9] * d_y + matrix[13]) / camear_z * py;

        float X = r_x - (r_y - r_w) / 4;
        float Y = (r_y);
        float W = (r_y - r_w) / 2;
        float H = (r_y - r_w);

        PlayerCount++;
        if (W > 0)
        {
            if (hack.box)
            {
                ImGui::GetForegroundDrawList()->AddRect({X - (W / 2), (Y - W)}, {X + (W / 2), Y + W}, color.BotColor, {0.0}, 0, {2});
            }
            if (hack.U3D)
            {
                // unity3d立体框算法

                // 开始定义射线位置

                float fkx1 = px + (matrix[0] * (d_x + 0.4) + matrix[4] * (d_z + 0.75) + matrix[8] * (d_y + 0.4) + matrix[12]) / camera * px;
                // 上左上
                float fkx2 = px + (matrix[0] * (d_x - 0.4) + matrix[4] * (d_z + 0.75) + matrix[8] * (d_y + 0.4) + matrix[12]) / camera * px;
                // 上右下
                float fkx3 = px + (matrix[0] * (d_x + 0.4) + matrix[4] * (d_z - 0.75) + matrix[8] * (d_y + 0.4) + matrix[12]) / camera * px;
                // 上左下
                float fkx4 = px + (matrix[0] * (d_x - 0.4) + matrix[4] * (d_z - 0.75) + matrix[8] * (d_y + 0.4) + matrix[12]) / camera * px;
                // 上右上
                float fky1 = py - (matrix[1] * (d_x + 0.4) + matrix[5] * (d_z + 0.75) + matrix[9] * (d_y + 0.4) + matrix[13]) / camera * py;
                // 上左上
                float fky2 = py - (matrix[1] * (d_x - 0.4) + matrix[5] * (d_z + 0.75) + matrix[9] * (d_y + 0.4) + matrix[13]) / camera * py;
                // 上右下
                float fky3 = py - (matrix[1] * (d_x + 0.4) + matrix[5] * (d_z - 0.75) + matrix[9] * (d_y + 0.4) + matrix[13]) / camera * py;
                // 上左下
                float fky4 = py - (matrix[1] * (d_x - 0.4) + matrix[5] * (d_z - 0.75) + matrix[9] * (d_y + 0.4) + matrix[13]) / camera * py;
                // 下右上
                float fkx5 = px + (matrix[0] * (d_x + 0.4) + matrix[4] * (d_z + 0.75) + matrix[8] * (d_y - 0.4) + matrix[12]) / camera * px;
                // 下左上
                float fkx6 = px + (matrix[0] * (d_x - 0.4) + matrix[4] * (d_z + 0.75) + matrix[8] * (d_y - 0.4) + matrix[12]) / camera * px;
                // 下右下
                float fkx7 = px + (matrix[0] * (d_x + 0.4) + matrix[4] * (d_z - 0.75) + matrix[8] * (d_y - 0.4) + matrix[12]) / camera * px;
                // 下左下
                float fkx8 = px + (matrix[0] * (d_x - 0.4) + matrix[4] * (d_z - 0.75) + matrix[8] * (d_y - 0.4) + matrix[12]) / camera * px;
                // 下右上
                float fky5 = py - (matrix[1] * (d_x + 0.4) + matrix[5] * (d_z + 0.75) + matrix[9] * (d_y - 0.4) + matrix[13]) / camera * py;
                // 下左下
                float fky6 = py - (matrix[1] * (d_x - 0.4) + matrix[5] * (d_z + 0.75) + matrix[9] * (d_y - 0.4) + matrix[13]) / camera * py;
                // 下右下
                float fky7 = py - (matrix[1] * (d_x + 0.4) + matrix[5] * (d_z - 0.75) + matrix[9] * (d_y - 0.4) + matrix[13]) / camera * py;
                // 下左下
                float fky8 = py - (matrix[1] * (d_x - 0.4) + matrix[5] * (d_z - 0.75) + matrix[9] * (d_y - 0.4) + matrix[13]) / camera * py;
                ImColor bone_color = color.HpColor;
                float bonesWidth = 1;
                // 连线开始

                ImGui::GetBackgroundDrawList()->AddLine({fkx1, fky1}, {fkx2, fky2}, bone_color, bonesWidth);
                ImGui::GetBackgroundDrawList()->AddLine({fkx3, fky3}, {fkx4, fky4}, bone_color, bonesWidth);
                ImGui::GetBackgroundDrawList()->AddLine({fkx1, fky1}, {fkx3, fky3}, bone_color, bonesWidth);
                ImGui::GetBackgroundDrawList()->AddLine({fkx2, fky2}, {fkx4, fky4}, bone_color, bonesWidth);

                ImGui::GetBackgroundDrawList()->AddLine({fkx5, fky5}, {fkx6, fky6}, bone_color, bonesWidth);
                ImGui::GetBackgroundDrawList()->AddLine({fkx7, fky7}, {fkx8, fky8}, bone_color, bonesWidth);
                ImGui::GetBackgroundDrawList()->AddLine({fkx5, fky5}, {fkx7, fky7}, bone_color, bonesWidth);
                ImGui::GetBackgroundDrawList()->AddLine({fkx6, fky6}, {fkx8, fky8}, bone_color, bonesWidth);

                ImGui::GetBackgroundDrawList()->AddLine({fkx1, fky1}, {fkx2, fky2}, bone_color, bonesWidth);
                ImGui::GetBackgroundDrawList()->AddLine({fkx3, fky3}, {fkx4, fky4}, bone_color, bonesWidth);
                ImGui::GetBackgroundDrawList()->AddLine({fkx1, fky1}, {fkx3, fky3}, bone_color, bonesWidth);
                ImGui::GetBackgroundDrawList()->AddLine({fkx2, fky2}, {fkx4, fky4}, bone_color, bonesWidth);

                ImGui::GetBackgroundDrawList()->AddLine({fkx1, fky1}, {fkx5, fky5}, bone_color, bonesWidth);
                ImGui::GetBackgroundDrawList()->AddLine({fkx2, fky2}, {fkx6, fky6}, bone_color, bonesWidth);
                ImGui::GetBackgroundDrawList()->AddLine({fkx3, fky3}, {fkx7, fky7}, bone_color, bonesWidth);
                ImGui::GetBackgroundDrawList()->AddLine({fkx4, fky4}, {fkx8, fky8}, bone_color, bonesWidth);

                // 连线结束
            }
            if (hack.line)
            {
                ImGui::GetForegroundDrawList()->AddLine(
                    {px, py}, {X, Y}, color.BotColor, {1});
            }
            if (hack.Sid)
            {
                char CSid[128];
                sprintf(CSid, "id:%d -> %lx", i, object);
                ImGui::GetForegroundDrawList()->AddText(NULL, 20, {X - W, Y + H / 2}, ImColor(255, 255, 255), CSid);
            }
            if (hack.distance)
            {
                std::string s;
                s += "[";
                s += std::to_string((int)jl);
                s += " m]";
                auto textSize = ImGui::CalcTextSize(s.c_str(), 0, 25);
                ImGui::GetForegroundDrawList()->AddText(NULL, 18, {X - W / 2, Y - H / 2}, color.DistanceColor, s.c_str());
            }
            if (hack.people)
            {
                ImGui::GetForegroundDrawList()->AddRectFilled({px - 50, 100 - 30}, {px + 50, 100 + 30}, ImColor(0, 255, 0), {40});
                std::string str1;
                str1 += to_string(PlayerCount);
                auto textSize = ImGui::CalcTextSize(str1.c_str(), 0, 25);
                ImGui::GetForegroundDrawList()->AddText(NULL, 30, {px + 3 - (textSize.x / 2), 85}, ImColor(255, 255, 255), str1.c_str());
            };
        };
    };
    PlayerCount = 0;
};

void *ESP_Op(void *a)
{
    EESP *aa = (EESP *)a;
    while (true)
    {
        if (aa->ESP_bool)
        {
            aa->ipid = getProcessID("com.dvloper.thetwins");
            pid = aa->ipid;
            if (pid <= 0)
            {
                std::cout << "请在游戏启动后注入\n";
            };
            aa->libbase = getbss(aa->ipid, "libunity.so");
            // libunity.so:bss[1] + 0x5CD88 -> 0x1C0 -> 0x34 -> 0xC4
            aa->Matrix = getPtr32(getPtr32(getPtr32(aa->libbase + 0x5CD88) + 0x1C0) + 0x34) + 0xC4; // 矩阵
            // libunity.so:bss[1] + 0x34D4C -> 0x8 -> 0xFC -> 0x4
            aa->MSF = getPtr32(getPtr32(getPtr32(aa->libbase + 0x34D4c) + 0x8) + 0xFC) + 0x4;
            aa->count = getDword(aa->MSF) - 258 + 44;
            aa->ESP_bool = false;
        }
        sleep(1);
    }
    return NULL;
}

void ImGui_init()
{
    if (g_Initialized)
    {
        return;
    }
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO &io = ImGui::GetIO();
    io.IniFilename = NULL;
    ImGui_ImplAndroid_Init(native_window);
    ImGui::StyleColorsLight();
    ImGui_ImplOpenGL3_Init("#version 300 es");
    io.Fonts->AddFontFromMemoryTTF((void *)OPPOSans_H, OPPOSans_H_size, 35.0f, NULL, io.Fonts->GetGlyphRangesChineseFull());
    ImGui::GetStyle().ScaleAllSizes(6.0f);
    g_Initialized = true;
    ImGuiStyle &style = ImGui::GetStyle();
    style.ScrollbarSize = 30;                  // 设置滚动条宽度
    style.ScaleAllSizes(1.3);                  // 设置控件内距
    style.WindowRounding = 20;                 // 设置边框圆角
    style.FrameBorderSize = 2;                 // 设置控件描边宽度
    style.WindowTitleAlign = ImVec2(0.5, 0.5); // 设置标题居中
    style.FramePadding = ImVec2(10, 10);       // 设置标题栏宽度
                                               // style.Alpha = 0.6f;//背景透明
};

void tick(EESP *a)
{
    ImGuiIO &io = ImGui::GetIO();
    if (display == EGL_NO_DISPLAY)
        return;
    static ImVec4 clear_color = ImVec4(0, 0, 0, 0);

    ImGui_ImplOpenGL3_NewFrame();
    ImGui_ImplAndroid_NewFrame(init_screen_x, init_screen_y);
    ImGui::NewFrame();

    ImGuiStyle &Style = ImGui::GetStyle();
    Style.GrabRounding = 4;
    Style.GrabMinSize = 10;
    Style.WindowRounding = 10.0f;  // 设置边框圆角
    Style.FrameBorderSize = 0.0f;  // 设置控件描边宽度
    Style.WindowBorderSize = 0.5f; // 设置框架描边宽度
    Style.FrameRounding = 10.0f;   // 控件圆角
    Style.FramePadding = ImVec2(5, 5);
    Style.WindowMinSize = ImVec2(500, 0);

    static bool show_ChildMenu1 = true;
    static bool show_ChildMenu2 = false;
    static bool show_ChildMenu3 = false;

    ImGui::Begin("the thwins MOD_Menu");

    if (ImGui::BeginChild("##mMenu", ImVec2(160, 0), false, ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NavFlattened))

    {
        ImGui::Text("ESP Menu");
        if (ImGui::Button("说明", ImVec2(160, 72)))
        {
            show_ChildMenu1 = true;
            show_ChildMenu2 = false;
            show_ChildMenu3 = false;
        }
        if (ImGui::Button("绘制", ImVec2(160, 72)))
        {
            show_ChildMenu1 = false;
            show_ChildMenu2 = true;
            show_ChildMenu3 = false;
        }
        if (ImGui::Button("HOOK", ImVec2(160, 72)))
        {
            show_ChildMenu1 = false;
            show_ChildMenu2 = false;
            show_ChildMenu3 = true;
        }
        if (ImGui::Button("退出", ImVec2(160, 72)))
        {
            exit(0);
        }
        ImGui::EndChild(); // 需要和ImGui::BeginChild成对出现。
    }

    ImGui::SameLine();
    if (show_ChildMenu1)
    {
        if (ImGui::BeginChild("##说明", ImVec2(0, 0), true))
        {
            ImGui::Text("HOOK->请初始化绘制");
            ImGui::Text("游戏PID:%d \ncount = %d\nlibbase = %lx\nMatrix =%lx\nMSF = %lx \n By effectae", pid, a->count, a->libbase, a->Matrix, a->MSF);

            ImGui::EndTabItem();
        }
    };

    if (show_ChildMenu2)
    {
        if (ImGui::BeginChild("##绘制", ImVec2(0, 0), true))
        {
            ImGui::Checkbox("绘制", &hack.esp);
            ImGui::SameLine();

            ImGui::Checkbox("人数", &hack.people);

            ImGui::Checkbox("方框", &hack.box);
            ImGui::SameLine();

            ImGui::Checkbox("射线", &hack.line);

            ImGui::Checkbox("Sid", &hack.Sid);
            ImGui::SameLine();

            ImGui::Checkbox("距离", &hack.distance);

            ImGui::Checkbox("3D", &hack.U3D);

            ImGui::EndTabItem();
        }
    }

    if (show_ChildMenu3)
    {
        if (ImGui::BeginChild("##HOOK", ImVec2(0, 0), true))
        {
            if (ImGui::Button("初始化绘制", ImVec2(145, 50)))
            {
                a->ESP_bool = true;
            }
            ImGui::EndTabItem();
        }
    };

    if (hack.esp == true)
    {
        // start
        startesp(a);
    }

    // FSP show
    char CSFSP[64];
    sprintf(CSFSP, "帧率 %.3f FPS", ImGui::GetIO().Framerate);
    ImGui::GetForegroundDrawList()->AddText(NULL, 30, {85, 85}, ImColor(255, 255, 255), CSFSP);

    ImGui::Render();
    glViewport(0, 0, (int)io.DisplaySize.x, (int)io.DisplaySize.y);
    glClearColor(clear_color.x * clear_color.w, clear_color.y * clear_color.w, clear_color.z * clear_color.w, clear_color.w);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
    eglSwapBuffers(display, surface);
};
