
int total(int start, int end){
    int sum = 0;
    for(int i = 1; i <= 10; i++) sum += i;
    return sum;
}

int mips_main(){
    return total(1, 10);
}
