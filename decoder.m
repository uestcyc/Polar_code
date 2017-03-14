function [u_hat,free_index]=decoder(y,Z,k,b,var)
%���뺯��
%����yΪ�ŵ����,ZΪ�ŵ�Bhattacharyya����,kΪ��Ϣ����,bΪfrozenbit��ֵ,varΪ��������/����

N=length(y);                        %�볤N
[Zw,index]=sort(Z,'descend');       %�ŵ�Bhattacharyya��������
frozen_index=index(1:N-k);          %frozenbitλ��
free_index=index(N-k+1:N);          %��Ϣ����λ��

isfrozen(frozen_index)=1;           %frozenbit���
isfrozen(free_index)=0;             %��Ϣ����


u_hat(1:N)=0;
for i=1:N
    if isfrozen(i)==1;
        u_hat(i)=b;
    else
        h=llr_new(y,u_hat,N,i,var);
        if h>=1
            u_hat(i)=0;
        else
            u_hat(i)=1;
        end
    end
end

end
        

