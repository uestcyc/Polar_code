function [u_hat,free_index]=decoder_list(y,free_index,frozen_index,b,var,L)
%���뺯��
%����yΪ�ŵ����,free_indexΪ��Ϣ����λ�ã�frozen_indexΪ�������λ��,kΪ��Ϣ����,bΪfrozenbit��ֵ,varΪ��������/����
%LΪ����������·����Ŀ
N=length(y);                        %�볤N


isfrozen(frozen_index)=1;           %frozenbit���
isfrozen(free_index)=0;             %��Ϣ����

%����ΪSCL���벿��
selections(L,N)=0;                            %��ѡ·��
node(1:2*L)=0;                           %ÿ�����ڵ��µ�2���ӽڵ��APPֵ���ں�ѡ·������֮������ѡ·�Ƚ�
                                                %��(2i-1)�д����i���ڵ�ȡ0��logAPP����(2i)�д����i���ڵ�ȡ1��logAPP
flag=0;                                     %��ǰ�뵽����Ϣ����
for i=1:N
    if isfrozen(i)==0
    flag=flag+1;
        if 2^flag <= L                                                                     %�ں�ѡ·��������֮ǰ������û�ж�logAPP���м���
            if flag == 1
                selections(1,i) = 0;
                selections(2,i) = 1;
            else
                temp=selections;
                for j=1:2^(flag-1)
                    selections(2*j-1,:)=temp(j,:);
                    selections(2*j,:)=temp(j,:);

                    selections(2*j-1,i)=0;                                          %·������
                    selections(2*j,i)=1;   
                end

            end
        else

            for j=1:L
                selections_temp(2*j-1,:)=selections(j,:);
                selections_temp(2*j,:)=selections(j,:);
                selections_temp(2*j-1,i)=0;
                selections_temp(2*j,i)=1;
                
                node(2*j-1)=logAPP1(y,selections(j,:),0,N,i,var);%logAPP�ļ���
                node(2*j)=logAPP1(y,selections(j,:),1,N,i,var);%
                
            end
        [~,I]=sort(node,'descend');
        selections=selections_temp(I(1:L),:);
        end
    end
end
u_hat=selections(1,:);      
end
        

