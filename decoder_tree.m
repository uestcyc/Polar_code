function u_hat=decoder_tree(y,free_index,frozen_index,b,var)
%���뺯��
%����yΪ�ŵ����,ZΪ�ŵ�Bhattacharyya����,kΪ��Ϣ����,bΪfrozenbit��ֵ,varΪ��������/����

N=length(y);                        %�볤N



isfrozen(frozen_index)=1;           %frozenbit���
isfrozen(free_index)=0;             %��Ϣ����


u_hat(1:N)=0;
for i=1:N
    if isfrozen(i)==1;
        u_hat(i)=b;
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

end
        

