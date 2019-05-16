/*
Name: Cache Simulator
Author: Vipul Sharma (B17069)
*/

#include <bits/stdc++.h>
using namespace std;

#define uint unsigned int

const int N = 2000000;
uint arr[N];
uint cmiss[10], lmiss[10], fmiss[10], ccache[20000];

pair<int,int> fifo[20000][4];
pair<int,int> lru[20000][4];

uint hextoint(string hex)                               // Converts hexadecimal addresses to unsigned ints
{
    int i, len = hex.length();
    int base = 1;
    uint res = 0;
    for (i=len-1;i>=0;i--) {
        if (hex[i]>='0' && hex[i]<='9') {
            res+=(hex[i]-'0')*base;
        }
        else if (hex[i]>='A' && hex[i]<='F') {
            res+=(hex[i]-'A'+10)*base;
        }
        base=base*16;
    }
    return res;
}

void findRes(int blockSize){
    ifstream inFile("address.txt");
    string tmp;
    int i, j, c = 0;
    while (inFile >> tmp) {
        uint addr = hextoint(tmp);
        arr[c] = addr/blockSize;
        c++;
    }
    for (int cs=1024;cs<=8192;cs<<=1) {                 // cs = cache size
        cmiss[cs/1024]=0;
        lmiss[cs/1024]=0;
        fmiss[cs/1024]=0;
        int cmb = cs/blockSize;                         // cmb = cache memory blocks
        int cms = cmb/4;                                // cms = number of sets in cache
        for (i=0;i<cmb;i++){
            ccache[i]=-1;
        }
        for (i=0;i<cms;i++){
            for (j=0;j<4;j++){
                fifo[i][j]={-1,-1};
                lru[i][j]={-1,-1};
            }
        }
        int timestamp=0;
        for (i=0;i<c;i++){                              // c = number of addresses in file
            
            // For Direct Mapping
            int cbn=arr[i]%cmb;                         // cbn = cache block number
            if (ccache[cbn] != arr[i]) {
                cmiss[cs/1024]++;
                ccache[cbn]=arr[i];
            }
            
            // For FIFO 4 way set associative
            int csn=arr[i]%cms;                         // csn = cache set number
            int found=0;
            for (j=0;j<4;j++){
                if (fifo[csn][j].first==arr[i]){
                    found=1;                            // Dont update timestamp if found in FIFO
                    break;
                }
            }
            if (found==0){
                fmiss[cs/1024]++;
                int mintimestampj=0, mintimestamp=INT_MAX;
                for (j=0;j<4;j++){
                    if (fifo[csn][j].second<mintimestamp){
                        mintimestamp = fifo[csn][j].second;
                        mintimestampj = j;
                    }
                }
                fifo[csn][mintimestampj]={arr[i], timestamp};
            }

            // For LRU 4 way set associative
            found=0;
            for (j=0;j<4;j++){
                if (lru[csn][j].first==arr[i]){
                    found=1;
                    lru[csn][j].second=timestamp;           // Update timestamp if found in LRU
                    break;
                }
            }
            if (found==0){
                lmiss[cs/1024]++;
                int mintimestampj=0, mintimestamp=INT_MAX;
                for (j=0;j<4;j++){
                    if (lru[csn][j].second<mintimestamp){
                        mintimestamp = lru[csn][j].second;
                        mintimestampj = j;
                    }
                }
                lru[csn][mintimestampj]={arr[i], timestamp};
            }
            timestamp++;
        }
    }
    cout<<"Number of misses for cache block size "<<blockSize<<" bits:\n";
    cout<<"Size  Direct   FIFO     LRU\n";
    for (int cs=1024;cs<=8192;cs<<=1) { 
        cout<<cs<<"  "<<cmiss[cs/1024]<<"  "<<fmiss[cs/1024]<<"  "<<lmiss[cs/1024]<<"\n";
    }
    cout<<"\n";
    cout<<"Miss Ratio for cache block size "<<blockSize<<" bits:\n";
    cout<<"Size  Direct    FIFO      LRU\n";
    for (int cs=1024;cs<=8192;cs<<=1) { 
        cout<<fixed<<setprecision(6)<<cs<<"  "<<(double(cmiss[cs/1024])/double(c))<<"  "<<(double(fmiss[cs/1024])/double(c))<<"  "<<(double(lmiss[cs/1024])/double(c))<<"\n";
    }
    cout<<"\n";    
}

int main()
{
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    findRes(16);
    findRes(32);
    return 0;
}
