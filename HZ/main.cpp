#include "AXA.hpp"

int main(int argc, char **argv)
{
	// 读取进程
	AXA *a = new AXA;
	char baom[]="com.dvloper.thetwins";
	int ipid = a->getPID(baom);//填写包名
       printf("要调试的进程PID是16进制=%d\n", ipid);//值是16进制
	float matrix[50], px, py, angle;
	 a->Startpid(ipid);
	// 分辨率获取
	FILE *fp = fopen("/sdcard/x", "r");//*fp意思是指针的意思，指向那个文件并且读取fopen为函数
	FILE *fp1 = fopen("/sdcard/y", "r");
	if (fp == NULL || fp1 == NULL)	// 如果没有读取到分辨率文件,则设置以下分辨
	{
		px = 1080.0;
		py = 2400.0;
	}
	else
	{
		fscanf(fp, "%f", &px);
		fscanf(fp1, "%f", &py);
		if (py > px)
		{
			float t = px;
			px = py;
			py = t;
		}
		py = py / 2.0;
		px = px / 2.0;
		fclose(fp);
		fclose(fp1);
	}
	char mname[] = "libunity.so";	
	long int unitybss = a->getbss(ipid, mname);
	printf("unitybss=%lx\n", unitybss);
//libunity.so:bss[1] + 0x5CD88 -> 0x1C0 -> 0x34 -> 0xC4
    long int Matrix = a->lsp32(a->lsp32(a->lsp32(unitybss + 0x5CD88) + 0x1C0) + 0x34) + 0xC4;//矩阵地址
    printf("矩阵地址=%lx\n", Matrix);
    //libunity.so:bss[1] + 0x34D4C -> 0x8 -> 0xFC -> 0x4
    long int Mad = a->lsp32(a->lsp32(a->lsp32(unitybss + 0x34D4C) + 0x8) + 0xFC) + 0x4;
		printf("Mad=%d\n*Mad=%lx\n", a->GainT<int>(Mad),Mad);
		
	FILE *F;
	while ((F = fopen("/sdcard/stop", "r")) == NULL)	
	{
		char aaa[30720] = "";	// 为变量申请内存
		char b[256];

		// 获取矩阵
		for (int i = 0; i < 16; i++)
		{
			float matrixaddr = a->GainT<float>(Matrix + i * 4);
			matrix[i] = matrixaddr;
		}

		// 获取坐标
		for (int i = 1; i <=44; i++)//想要不绘制自己,count-1即可
		{
			long int objaddrzz = a->lsp32(Mad + i*4);//数组
			// 敌人坐标
			float d_x = a->GainT<float>(objaddrzz + 0x60);
			float d_z = a->GainT<float>(objaddrzz + 0x60 + 0x4);
			float d_y = a->GainT<float>(objaddrzz + 0x60 + 0x8);
			
			
			// 距离算法
			float camear_z = matrix[3] * d_x + matrix[7] * d_z + matrix[11] * d_y + matrix[15];//相机Z
                                               int jl = camear_z/1;
		// 矩阵
float camear_r = matrix[3] * d_x + matrix[7] * d_z + matrix[11] * d_y + matrix[15];

float r_x = px + (matrix[0] * d_x + matrix[4] *d_z+ matrix[8] * d_y + matrix[12]) / camear_z * px;//视角高

float r_y = py -  (matrix[1] * d_x + matrix[5] * (d_z-0.3) + matrix[9] * d_y + matrix[13]) / camear_z * py;//;视角宽

float r_w = py - (matrix[1] * d_x + matrix[5] * (d_z +1.8) + matrix[9] * d_y + matrix[13]) / camear_z * py;
			
float X=r_x - (r_y - r_w) / 4;
float Y=(r_y) ;
float W=(r_y- r_w) / 2 ;
float H=(r_y - r_w) ;		  


					  
int dt = 0;
int dw =1;//队伍ID
int bot = 1;//人机识别0为人机,则不绘制名字 ,1则绘制名字		  
			sprintf(b, "%f,%f,%f,%f,%d,%d,%d,%d,%d,%d,\n",
			        X,	// 1.x
					Y,
					W,
					H,
				  jl, //距离               
					100,//hp,// 6.血量
					bot,
					dw,
					dt,
				   i// Name
			//	    objaddrzz
				);
			strcat(aaa, b);
		}

		int fd = open("/sdcard/b.log", O_WRONLY | O_CREAT);
		write(fd, aaa, sizeof(aaa));	// 写入文本
		close(fd);
		 usleep(100);
	}
}