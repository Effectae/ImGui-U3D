#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <dirent.h>
#include <pthread.h>
#include <sys/socket.h>
#include <malloc.h>
#include <math.h>
#include <iostream>
#include <sys/stat.h>
#include <errno.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <iostream>
#include <locale>
#include <codecvt>

class AXA
{
private:
	int pid = 0;
	long int handle;
	bool T = false;
  public:
int getPID(const char *packageName);
int getpid(){return pid;}
void Startpid(int ipid){
char lj[64];
	sprintf(lj, "/proc/%d/mem", ipid);
	handle = open(lj, O_RDWR);
	if (handle == 0)
	{
		puts("获取mem失败!");
		exit(1);
	}
	}
long int getXa(int pid, const char *module_name);
long getbss(int pid, const char *module_name);
long getCd(int pid, const char *module_name);
//32位指针
long int lsp32(long int addr)
{
	long int var = 0;
	pread64(handle, &var, 4, addr);
	return var;
}
//64位指针
long int lsp64(long int addr)
{
	long int var = 0;
	pread64(handle, &var, 8, addr);
	return var;
}
template< class T > 
T GainT(long int addr){
T var = 0;
	pread64(handle, &var, sizeof(T), addr);
	return var;
}
template < class T > 
void WriteT(long int addr,T value){
pwrite64(handle, &value, sizeof(T), addr);
}
};
int AXA::getPID(const char *packageName)
{
	int id = -1;
	DIR *dir;
	FILE *fp;
	char filename[64];
	char cmdline[64];
	struct dirent *entry;
	dir = opendir("/proc");
	while ((entry = readdir(dir)) != NULL)
	{
		id = atoi(entry->d_name);
		if (id != 0)
		{
			sprintf(filename, "/proc/%d/cmdline", id);
			fp = fopen(filename, "r");
			if (fp)
			{
				fgets(cmdline, sizeof(cmdline), fp);
				fclose(fp);
				if (strcmp(packageName, cmdline) == 0)
				{
					return id;
				}
			}
		}
	}
	closedir(dir);
	return -1;
}
long int AXA::getXa(int pid, const char *module_name)
{
	FILE *fp;
	long addr = 0;
	char *pch;
	char filename[64];
	char line[1024];
	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
	fp = fopen(filename, "r");
	if (fp != NULL)
	{
		while (fgets(line, sizeof(line), fp))
		{
			if (strstr(line, module_name))
			{
				pch = strtok(line, "-");
				addr = strtoul(pch, NULL, 16);
				if (addr == 0x8000)
					addr = 0;
				break;
			}
		}
		fclose(fp);
	}
	return addr;
}
long AXA::getbss(int pid, const char *module_name)
{
	FILE *fp;
	long addr = 0;
	char *pch;
	char filename[64];
	char line[1024];
	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
	fp = fopen(filename, "r");
	bool is = false;
	if (fp != NULL)
	{
		while (fgets(line, sizeof(line), fp))
		{
			if (strstr(line, module_name ))
			{
				is = true;
			}
			if (is)
			{
				if (strstr(line, "[anon:.bss]"))
				{
					sscanf(line, "%X", &addr);
					break;
				}
			}
		}
		fclose(fp);
	}
	return addr;
}
long AXA::getCd(int pid, const char *module_name)
{
	FILE *fp;
	long addr = 0;
	char *pch;
	char filename[64];
	char line[1024];
	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
	fp = fopen(filename, "r");
	char str[100];
	sprintf(str, "-%x", getbss(pid, module_name));
	if (fp != NULL)
	{
		while (fgets(line, sizeof(line), fp))
		{
			if (strstr(line, str ))
			{
				sscanf(line, "%X", &addr);
				break;
			}
		}
		fclose(fp);
	}
	return addr;
}
