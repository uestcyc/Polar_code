%awgn�ŵ��µļ��������ܷ���
%ʹ����ƽ���ֲ�SCL-CRC����
%��������  NΪ�볤,nΪlog2(N),kΪ��Ϣ����,ZwΪ�ŵ�Bhattacharyyaֵ,bΪfrozenbit��ֵ
%GΪCRC���ɾ���KΪ��Ϣ����CRC֮��ĳ���
%layer_boundΪÿ�����λ��,layer_number�ֲ�Ĳ���
clear
FRAMES=input('frames=');
MAX_FRAME_ERROR=input('max frame error=');
G=[1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1]
%G=[1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1];

n=input('n=');
N=2^n                                                  %�����ĳ�ʼ��
K=input('K=');                                         %��Ϣ��CRC֮��ĳ���
k=K+1-length(G)                                   %��Ϣ����
R=K/N                                                   %���ʣ����ݳ¿����ģ�����ʹ��K/N������
SNR_dB=input('SNR_dB=');                       %
b=0;                        
L=32%input('L=');
err_position=zeros(length(SNR_dB),k);    %ÿ������λ�õĴ�����Ŀ

for j=1:length(SNR_dB)
%����SNR_dB����������ʣ����������ʵݹ��ϵ����     
SNR_not_dB(j)=10^(SNR_dB(j)/10);         %ת���ɷ�dB��ʽ
var(j)=1/(2*R*SNR_not_dB(j));                       %�õ���������sigma^2
%eb=exp(-1/(2*var(j)));
frame_error=0;
bit_err_num=zeros(1,FRAMES);
bit_err_pos=zeros(FRAMES,k);
Z=get_awgn_Pb(N,var(j));                   %�ŵ���Bhattacharyya��������
uc(1:N)=0;
[Zw,index]=sort(Z,'descend');       %���ս������о���Z
free_index=index(N-K+1:N);          %��Ϣ���ص�λ��
%[free_index,~]=sort(free_index,'ascend');
frozen_index=index(1:N-K);          %frozenbit��λ��
uc(frozen_index)=b;                 
for frame=1:FRAMES
 
 tic
%��Ϣ������
%uΪ��Ϣ����
rng('shuffle')
u=randsrc(1,k,[0 1]);
u_crc=crc_gen(u,G,K);                                   %����CRCУ����
%�ŵ���ѡ��
%����Bhattacharyya��������ѡ��


%��Ϣ�ı���
uc(free_index)=u_crc;
%����õ�������Ϊx
x=encoder(uc);

%AWGN�ŵ�
y=awgn_noise(x,var(j));
%����
u_hat_crc=decoder_list_crc(y,free_index,frozen_index,b,var(j),L,G);

%��֡�ʣ�ֱ��ͳ����֡���ˣ���ͳ�������ʣ�
if isempty(u_hat_crc)==1
    frame_error=frame_error+1;
else
    [bit_err_num(frame),~,bit_err_pos(frame,:)]=biterr(u,u_hat_crc(free_index(1:k)));
    if bit_err_num(frame)~=0
        frame_error=frame_error+1;
    end
end
err_position(j,:)=err_position(j,:)+bit_err_pos(frame,:);
frame
if frame_error==MAX_FRAME_ERROR
    break;
end

end
BER(j)=sum(bit_err_num)/(k*FRAMES)
FER(j)=frame_error/frame
toc
%dlmwrite('SC_1024_CRC_24.txt',FER(j),'-append');
end

%semilogy(SNR_dB,FER,'-*b')