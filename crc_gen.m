function u_crc=crc_gen(x,G,N)
%crcУ�������ɺ���
%xΪ���� GΪ���ɶ���ʽ NΪ�����볤

crc_length=length(G);               %CRC���ɶ���ʽ�ĳ���
info_length=length(x);
quotient=[];                             %�̶���ʽ
remainder=[];                           %��������ʽ
u_crc(1:info_length)=x;
u_crc(info_length+1:N)=0;
register=[];                                %����ʱʹ�õ���ʱ����
for k=1:info_length
     if k==1
         register=u_crc(1:crc_length);
     else
         register(1:crc_length-1)=remainder;
         register(crc_length)=u_crc(k+crc_length-1);
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
u_crc(info_length+1:N)=remainder;
end