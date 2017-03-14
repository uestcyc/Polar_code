%awgn�ŵ��µĳ�������Ӧ���������ܷ���
%��������
%NΪ�볤,nΪlog2(N),kΪ��Ϣ����,ZwΪ�ŵ�Bhattacharyyaֵ,bΪfrozenbit��ֵ��M��puncturing֮����볤 retrans_abilityΪ����ش�����
clear
% FRAMES=input('frames=');
% MAX_FRAME_ERROR=input('max frame error=');
% 
% n=input('n=');N=2^n;                            %�����ĳ�ʼ��
% k=input('k=');                                  %
% R=k/N;                                          %
% SNR_dB=input('SNR_dB=');                       %
FRAMES=1;
MAX_FRAME_ERROR=20;
n=4;
N=2^n;                            %�����ĳ�ʼ��
M=16;                      %punctured���ֳ���
k=8;                                  %
R=k/M;                                          %
SNR_dB=2;                       %
b=0;                         %         %
retrans_ability=1; %��������ش�����retrans_ability 


for j=1:length(SNR_dB)
%����SNR_dB����������ʣ����������ʵݹ��ϵ����     
SNR_not_dB(j)=10^(SNR_dB(j)/10);         %ת���ɷ�dB��ʽ
var(j)=1/(2*R*SNR_not_dB(j));                       %�õ���������sigma^2
Z=get_awgn_bhattacharyya(N,var(j));                   %�ŵ���Bhattacharyya��������

%%     %%%%%%%�ȶ�Z����bit��ת������FN�ͷ�ת��Zֵ��frozenbitsλ�ã�����Z=1.1����bit��ת����

tic
%%%%����ط�ת���Z����
Z_rev=zeros(1,N);
for i=1:N
   Z_rev(i)=Z(bin2dec(fliplr(dec2bin(i-1,n)))+1);           %%bit��ת�󼫻��ŵ���Bhattacharyya����
end

%%%����bit��ת��ľ���FN
FN=eye(1);             
F0=[1 0;1 1];
for i=1:n
    FN=kron(FN,F0);
end
% GN=zeros(1,N);
% for i=1:N
%     GN(i,:)=FN(bin2dec(fliplr(dec2bin(i-1,n)))+1,:);           %%���ɾ���GN
% end

%% ѡ��frozen bits����F��puncture bits����P����frozenbit��Ӧ��Zֵ=1.1 
indeP=zeros(1,N-M);
puncFN=FN;
for i=1:(N-M)
  candiF=find (sum(puncFN)==1);   %%%Ѱ������Ϊ1���У�1�ڶԽ���λ�ã�����1�����к���ȣ�����1��������Ϊ��ѡfrozen bitλ 
  if length(candiF)==1   %%FNֻ��1����Ϊ1��ֱ����Ϊfrozen bitλ������Z�ɴ�Сѡ��
      indeP(i)=candiF;
  else
      indeP(i)=candiF(find(Z_rev((candiF))==max(Z_rev(candiF))));      
  end
      Z_rev(indeP(i))=1.1;
      puncFN(indeP(i),:)=0;
      puncFN(:,indeP(i))=0;
end
%% 
%%%�Եõ���Z_rev����bit��ת���õ�
Z_rev_rev=zeros(1,N);
for i=1:N
    Z_rev_rev(i)=Z_rev(bin2dec(fliplr(dec2bin(i-1,n)))+1);           %%bit��ת�󼫻��ŵ���Bhattacharyya����
end
toc
%% 

frame_error=0;
bit_err_num=zeros(1,FRAMES);
[Zw,index]=sort(Z_rev_rev,'descend');       %���ս������о���Z
free_index=index(N-k+1:N);          %��Ϣ���ص�λ��
frozen_index=index(1:N-k);          %frozenbit��λ��  
puncture_index=indeP;               %puncturebit��λ��
rechans_index=index(N-k+1:N-k+1+retrans_ability );          %�ش���Ϣ���ص�λ��
uc(frozen_index)=b;      
     


tic
for frame=1:FRAMES
     
%��Ϣ������
%uΪ��Ϣ����
u=randsrc(1,k,[0 1]);

%��Ϣ�ı���
%%%%%%%%%%%%%%%%%%%����֮ǰ��׼������%%%%%%%%%%%%%%%%%%%%%%%%%
uc(free_index)=u;

%����õ�������Ϊx
x=encoder(uc);

%AWGN�ŵ�
y=awgn_noise(x,var(j));
y(puncture_index)=-1;%%punctured bit��֪Ϊ0
%����
[u_hat,index]=decoder(y,Z_rev_rev,k,b,var(j));
%%input_data=u_hat(index)
%������

bit_err_num(frame)=biterr(u,u_hat(free_index));
if bit_err_num(frame)~=0
    ACK=0;  %���ý��ձ�־��0��ʾ�ܾ���1��ʾ����
else
    ACK=1;    
end
%% �ش�
L_recev=ones(1,N);
retrans_cnt = 0; %�����ش�����������
%% 
while ACK == 0 && retrans_cnt < retrans_ability  
    retrans_cnt = retrans_cnt+1;
    %�ش���Ϣλ����AWGN�ŵ�
    y_recev=awgn_noise(u(retrans_cnt),var(j));   %%��i���ش�
    L_recev(free_index(retrans_cnt))=exp(-2*y_recev/var);
    %����
%     [u_hat,index]=decoder(y,Z_rev_rev,k,b,var(j));
    [u_hat,index]=harq_decoder(y,L_recev,Z_rev_rev,k,b,var(j)); %%%  ��harq�ش������룺���ش�bit������Ϣ�ϲ�������
    bit_err_num(frame)=biterr(u,u_hat(free_index));    
    if bit_err_num(frame)~=0
        ACK=0;  %���ý��ձ�־��0��ʾ�ܾ���1��ʾ����
    else ACK=1;
    end  
end

bit_err_num(frame)=biterr(u,u_hat(free_index));
if bit_err_num(frame)~=0
    frame_error=frame_error+1;
end

     
  %% 


frame
retrans_cnt
if frame_error==MAX_FRAME_ERROR
    break;
end

end
toc
FER(j)=frame_error/frame
BER(j)=sum(bit_err_num)/(k*frame)
dlmwrite('polar_awgn_punc_harq.txt',FER(j),'-append');
end
%semilogy(SNR_dB,BER,'-+r',SNR_dB,FER,'-*b')