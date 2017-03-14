function u_hat=decoder_list_crc_layer(y,free_index,frozen_index,b,var,L,G,layer,crc_bound)
%���뺯��
%����yΪ�ŵ����,ZΪ�ŵ�Bhattacharyya����,kΪ��Ϣ����,bΪfrozenbit��ֵ,varΪ��������/����
%LΪ����������·����Ŀ
%GΪCRC���ɾ���
%layerΪ�ֳɵĲ���
N=length(y);                        %�볤N
stack=1;                            %ÿ�㱣����·������

isfrozen(frozen_index)=1;           %frozenbit���
isfrozen(free_index)=0;             %��Ϣ����

u_hat=[];                                   %������
u_hat_temp=zeros(1,N);                      %�ֶεı���·��
u_hat_temp_num=1;                           %�ֶ�·����Ŀ
%����ΪSCL���벿��
selections=zeros(L,N);                            %��ѡ·��
selections_temp=zeros(1,N);
node(1:2*L)=0;                           %ÿ�����ڵ��µ�2���ӽڵ��APPֵ���ں�ѡ·������֮������ѡ·�Ƚϣ���(2i-1)�д����i���ڵ�ȡ0��logAPP����(2i)�д����i���ڵ�ȡ1��logAPP
flag=[0,crc_bound(2:layer+1)];          %·����־

                                      
for ii=1:layer
    freeflag=u_hat_temp_num-1;                                                                                         %������¼��ǰ��Ϣ���������뵽��λ��
    for i=flag(ii)+1:flag(ii+1)
        if isfrozen(i)==0
            freeflag=freeflag+1;
            
            if 2^freeflag <= L                                                                     %�ں�ѡ·��������֮ǰ������û�ж�logAPP���м���
                
                selections_temp=selections;
                for j=1:2^(freeflag-1)
                    selections(2*j-1,:)=selections_temp(j,:);
                    selections(2*j,:)=selections_temp(j,:);

                    selections(2*j-1,i)=0;                                          %·������
                    selections(2*j,i)=1;   
                end

                
            else
                for j=1:L
                    selections_temp(2*j-1,:)=selections(j,:);
                    selections_temp(2*j,:)=selections(j,:);
                    selections_temp(2*j-1,i)=0;
                    selections_temp(2*j,i)=1;
                    
                    node(2*j-1)=logAPP1(y,selections(j,:),0,N,i,var);   %logAPP�ļ���
                    node(2*j)=logAPP1(y,selections(j,:),1,N,i,var);       %
                   
                end
                [~,I]=sort(node,'descend');
                selections=selections_temp(I(1:L),:);
            end
        end
        
            
    end
    %������CRCУ�鲿��
    free_layer=find(isfrozen(flag(ii)+1:flag(ii+1))~=1)+flag(ii);
    jjj=1;
    for kk=1:L
        result=crc_check(selections(kk,free_layer),G);
        if result==0
            u_hat_temp(jjj,:)=selections(kk,:);      %CRCУ��ͨ��
             jjj=jjj+1;
             if(jjj==stack+1)
                 break;                  %����·������
             end
        end
    end
u_hat_temp_num=size(u_hat_temp,1);    
    if jjj==1
       for pp=1:u_hat_temp_num
           u_hat_temp(pp,:)=selections(pp,:);%��û��·��ͨ��У��
       end
    end
    
selections=u_hat_temp;          %·�������ָ���ʼ��
node(1:2*L)=0; 
selections_temp=zeros(1,N);
end
u_hat=u_hat_temp(1,:);
end
        

