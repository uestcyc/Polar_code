%awgn�ŵ��µļ��������ܷ���
%ʹ����ƽ���ֲ�SCL-CRC����
%��������  NΪ�볤,nΪlog2(N),kΪ��Ϣ����,ZwΪ�ŵ�Bhattacharyyaֵ,bΪfrozenbit��ֵ
%GΪCRC���ɾ���KΪ��Ϣ����CRC֮��ĳ���
%layer_boundΪÿ�����λ��,layer_number�ֲ�Ĳ���
clear
FRAMES=200%input('frames=');
MAX_FRAME_ERROR=FRAMES%input('max frame error=');
G=[1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1]
n=7%input('n=');
N=2^n                                                  %�����ĳ�ʼ��
K=64%input('K=');                                         %��Ϣ��CRC֮��ĳ���
k=K+1-length(G)                                   %��Ϣ����
T=10     %����ش�����
repeatNumber = 1        %�ش��ı�����Ŀ
R=K/N                                                   %���ʣ����ݳ¿����ģ�����ʹ��K/N������
SNR_dB=input('SNR_dB=');                       %
b=0;                        
L=16%input('L=');
err_position=zeros(length(SNR_dB),k);    %ÿ������λ�õĴ�����Ŀ

for j=1:length(SNR_dB)
%����SNR_dB����������ʣ����������ʵݹ��ϵ����     
SNR_not_dB(j)=10^(SNR_dB(j)/10);         %ת���ɷ�dB��ʽ
var(j)=1/(2*R*SNR_not_dB(j));                       %�õ���������sigma^2
eb=exp(-1/(2*var(j)));
frame_error=0;
bit_err_num=zeros(1,FRAMES);
bit_err_pos=zeros(FRAMES,k);
Z=get_bec_bhattacharyya(N,eb);                   %�ŵ���Bhattacharyya��������
uc(1:N)=0;
[~,index]=sort(Z,'descend');       %���ս������о���Z
free_index_Z=index(N-K+1:N);          %��Ϣ���ص�λ��
[free_index,infoOrder]=sort(free_index_Z,'ascend');
repeatPos = free_index_Z(1:repeatNumber)
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
[u_hat_crc,crc_checked]=decoder_list_crc(y,free_index,frozen_index,b,var(j),L,G);

%HARQ����
t = 1;
    while(crc_checked ~= 1 && t<=T)
       t=t+1;
       y_repeat = awgn_noise(uc(repeatPos),var(j));
       y_repeat_ll = exp(-2*y_repeat./var(j));
       [u_hat_crc,crc_checked]=harq_decoder(y,y_repeat_ll,var(j),repeatPos,u_hat_crc,free_index,frozen_index,L,G);
    end

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