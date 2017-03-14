%awgn�ŵ��µļ��������ܷ���
%��������  NΪ�볤,nΪlog2(N),kΪ��Ϣ����,ZwΪ�ŵ�Bhattacharyyaֵ,bΪfrozenbit��ֵ
clear
FRAMES=input('frames=');
MAX_FRAME_ERROR=input('max frame error=');

n=input('n=');N=2^n;                            %�����ĳ�ʼ��
k=input('k=');                                  %
R=k/N;                                          %
SNR_dB=input('SNR_dB=');                       %
b=0;                         %
for j=1:length(SNR_dB)
%����SNR_dB����������ʣ����������ʵݹ��ϵ����     
SNR_not_dB(j)=10^(SNR_dB(j)/10);         %ת���ɷ�dB��ʽ
var(j)=1/(2*R*SNR_not_dB(j));                       %�õ���������sigma^2

Z=get_awgn_bhattacharyya(N,var(j));                   %�ŵ���Bhattacharyya��������
frame_error=0;
bit_err_num=zeros(1,FRAMES);
[Zw,index]=sort(Z,'descend');       %���ս������о���Z
free_index=index(N-k+1:N);          %��Ϣ���ص�λ��
frozen_index=index(1:N-k);          %frozenbit��λ��
uc(frozen_index)=b;                 

tic
for frame=1:FRAMES
 
 
%��Ϣ������
%uΪ��Ϣ����
rng('shuffle')
u=randsrc(1,k,[0 1]);

%�ŵ���ѡ��
%����Bhattacharyya��������ѡ��

%��Ϣ�ı���
%%%%%%%%%%%%%%%%%%%����֮ǰ��׼������%%%%%%%%%%%%%%%%%%%%%%%%%
uc(free_index)=u;

%����õ�������Ϊx
x=encoder(uc);

%AWGN�ŵ�
y=awgn_noise(x,var(j));
%����
[u_hat,index]=decoder(y,Z,k,b,var(j));
%%input_data=u_hat(index);

%������

bit_err_num(frame)=biterr(u,u_hat(free_index));
if bit_err_num(frame)~=0
    frame_error=frame_error+1;
end

frame
if frame_error==MAX_FRAME_ERROR
    break;
end

end
toc
FER(j)=frame_error/frame
BER(j)=sum(bit_err_num)/(k*frame)
dlmwrite('SC_1024.txt',FER(j),'-append');
end
%semilogy(SNR_dB,BER,'-+r',SNR_dB,FER,'-*b')