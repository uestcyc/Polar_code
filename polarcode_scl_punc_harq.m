%awgn�ŵ��µļ��������ܷ���
%ʹ����ƽ���ֲ�SCL-CRC����
%��������  NΪ�볤,nΪlog2(N),kΪ��Ϣ����,ZwΪ�ŵ�Bhattacharyyaֵ,bΪfrozenbit��ֵ
%GΪCRC���ɾ���KΪ��Ϣ����CRC֮��ĳ���
%layer_boundΪÿ�����λ��,layer_number�ֲ�Ĳ���
clear
FRAMES=100%input('frames=');
MAX_FRAME_ERROR=FRAMES%input('max frame error=');
G=[1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1]
L=16
n=10%input('n=');
N=2^n                                                  %�����ĳ�ʼ��
K=320%input('K=');                                         %��Ϣ��CRC֮��ĳ���
k=K+1-length(G)                                   %��Ϣ����
M=640
T=6     %����ش�����
repeatNumber = 1        %�ش��ı�����Ŀ
R=K/M                                                   %���ʣ����ݳ¿����ģ�����ʹ��K/N������
SNR_dB=input('SNR_dB=');                       %
b=0;                        
err_position=zeros(length(SNR_dB),k);    %ÿ������λ�õĴ�����Ŀ

P0=[zeros(1,N-M) ones(1,M)];
for i=1:N
    P0_v(:,i)=P0(1,bin2dec(fliplr(dec2bin(i-1,n)))+1);           %%bit-reversal
end
indeP=find(P0_v==0);%���λ��
indeR=find(P0_v==1);%����λ��


for j=1:length(SNR_dB)
%����SNR_dB����������ʣ����������ʵݹ��ϵ����     
SNR_not_dB(j)=10^(SNR_dB(j)/10);         %ת���ɷ�dB��ʽ
var(j)=1/(2*R*SNR_not_dB(j));                       %�õ���������sigma^2
%eb=exp(-1/(2*var(j)));
frame_error=0;
bit_err_num=zeros(1,FRAMES);
bit_err_pos=zeros(FRAMES,k);
[Z, M]=get_punc_awgn_Pb(N, var(j),indeR);                   %�ŵ���Bhattacharyya��������
uc(1:N)=0;
[~,index]=sort(Z,'descend');       %���ս������о���Z

free_index_Z=index(N-K+1:N);          %��Ϣ���ص�λ��

[free_index, infoOrder]=sort(free_index_Z,'ascend');

frozen_index=index(1:N-K);          %frozenbit��λ��
uc(frozen_index)=b;


for frame=1:FRAMES
free_index_harq=free_index_Z; 
M_info=M(free_index_Z);
Z_info=Z(free_index_Z);
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
yp(indeP)=0;
yp(indeR)=y(indeR);
%����
% [u_hat_crc,crc_checked]=decoder_tree_crc(yp, free_index, frozen_index, b, var(j), G);
u_hat_crc=decoder_list_crc(y,free_index,frozen_index,b,var,L,G);
%HARQ����
t = 1;
Z_harq=Z;
%     while(crc_checked ~= 1 && t<=T)
%        
%        repeatPos = free_index_harq(1)
%        y_repeat = awgn_noise(uc(repeatPos),var(j));
%        y_repeat_ll = (-2*y_repeat./var(j));
%        M_info(1)=(M_info(1)+2/var(j));
%        Z_info=1-qfunc(sqrt(M_info./2)*(-1));
%        [u_hat_crc,crc_checked]=harq_decoder_sc(yp,y_repeat_ll,var(j),repeatPos,u_hat_crc,free_index,frozen_index,G);
%        [Z_info, ppp]=sort(Z_info, 'descend');
%        M_info=M_info(ppp);
%        free_index_harq=free_index_harq(ppp);
%        t=t+1;
%        
%     end

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