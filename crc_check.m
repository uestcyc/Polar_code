function result=crc_check(x,G)
%CRCУ�麯��
%xΪ��У���CRC���֣�GΪCRC���ɶ���ʽ

crc_length=length(G);               %CRC���ɶ���ʽ�ĳ���
code_length=length(x);
quotient=[];                             %�̶���ʽ
remainder=[];                           %��������ʽ
register=[];                                %����ʱʹ�õ���ʱ����
for k=1:code_length-crc_length+1
     if k==1
         register=x(1:crc_length);
     else
         register(1:crc_length-1)=remainder;
         register(crc_length)=x(k+crc_length-1);
     end
     if register(1)~=1
         quotient(k)=0;
         remainder=register(2:crc_length);
         continue
     else
         quotient(k)=1;
         temp=bitxor(register,G);
         remainder=temp(2:crc_length);
     end
     
end

if(sum(remainder)==0)
    result=0;
else
    result=1;
end
end