function [u_hat,crc_checked]=harq_decoder(y,L_recev,var,repeatPos,u_hat,free_index,frozen_index,L,G)
%���뺯��
%����yΪ�ŵ����,ZΪ�ŵ�Bhattacharyya����,kΪ��Ϣ����,bΪfrozenbit��ֵ,varΪ��������/����
N = length(y);

for kk=1:length(repeatPos)
    u_lr = sqrt(L_recev(kk)*lr_new(y,u_hat,N,repeatPos(kk),var));
    if(u_lr >=1)
           u_hat(repeatPos(kk)) = 0;
    else
           u_hat(repeatPos(kk)) = 1;
    end
    
end
isfrozen(free_index)=0;
isfrozen(frozen_index)=1;

selections(L,N)=0;                            %��ѡ·��
node(1:2*L)=0;                           %ÿ�����ڵ��µ�2���ӽڵ��APPֵ���ں�ѡ·������֮������ѡ·�Ƚ�
                                                %��(2i-1)�д����i���ڵ�ȡ0��logAPP����(2i)�д����i���ڵ�ȡ1��logAPP
flag=0;            
for mm=1:length(repeatPos)
    for i=repeatPos(mm)+1:N
        if isfrozen(i)==0                                                             %������Ϣ���أ�����·����չ
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
    
    %������CRCУ�鲿��
    for kk=1:L
        result=crc_check(selections(kk,free_index),G);
        if result==0
            u_hat=selections(kk,:);      %CRCУ��ͨ��
            crc_checked = 1;
            return;                          
        end
    end
    if kk==L                                  %CRCУ��δͨ��
        u_hat=selections(1,:);
        crc_checked = 0;
    end

end
    

end
        

