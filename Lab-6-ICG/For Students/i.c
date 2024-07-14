int main(){
if(a > b)
{
a = a + 1;
b = b - 1;
if(a > b)
{
a = a + 1;
b = b - 1;
}
else
{
a = a - 1;
b = b -1;
}
}
else
{
a = a - 1;
b = b -1;
}
a=0;
}
