function [u_hat,crc_checked]=harq_decoder_sc(y,L_recev,var,repeatPos,u_hat,free_index,frozen_index,G)
%���뺯��
%����yΪ�ŵ����,ZΪ�ŵ�Bhattacharyya����,kΪ��Ϣ����,bΪfrozenbit��ֵ,varΪ��������/����
N = length(y);


u_lr = sqrt(L_recev*lr_new(y,u_hat,N,repeatPos,var));
if(u_lr >=1)
    u_hat(repeatPos) = 0;
else
    u_hat(repeatPos) = 1;
end




isfrozen(free_index)=0;
isfrozen(frozen_index)=1;

for i=repeatPos+1:N
    if isfrozen(i)==1;
        u_hat(i)=0;
    else
       M0=logAPP1(y,u_hat,0,N,i,var);
       M1=logAPP1(y,u_hat,1,N,i,var);
        if M0>=M1
            u_hat(i)=0;
        else
            u_hat(i)=1;
        end
    end
end

result=crc_check(u_hat(free_index),G);
if result==0
    crc_checked = 1;       %CRCУ��ͨ��
else
    crc_checked=0;

    

end
        

