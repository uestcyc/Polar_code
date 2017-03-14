%awgn�ŵ��µļ��������ܷ���
%ʹ����ƽ���ֲ�SCL-CRC����
%��������  NΪ�볤,nΪlog2(N),kΪ��Ϣ����,ZwΪ�ŵ�Bhattacharyyaֵ,bΪfrozenbit��ֵ
%GΪCRC���ɾ���KΪ��Ϣ����CRC֮��ĳ���
%layer_boundΪÿ�����λ��,layer_number�ֲ�Ĳ���
%����һ��ͨ��crcУ���·��
clear
FRAMES=input('frames=');
MAX_FRAME_ERROR=input('max frame error=');
layer=input('layer=');                              %�ֲ����
G=[1 0 0 0 0 0 1 1 1]
n=input('n=');
N=2^n                                                  %�����ĳ�ʼ��
K=input('K=');                                         %��Ϣ��CRC֮��ĳ���
k=K-(length(G)-1)*layer                              %��Ϣ����
K_layer=K/layer                                     %ÿ���ֶ�CRC���ֳ���
k_layer=k/layer                                      %ƽ���ֶ�֮��ÿ����Ϣ�ĳ���
crc_length_layer=length(G)-1                 %ÿ���ֶ�CRC���ֳ���
R=K/N                                                   %���ʣ�
SNR_dB=input('SNR_dB=');                    %
b=0;                        
L=32%input('L=');
err_position=zeros(length(SNR_dB),k);    %ÿ������λ�õĴ�����Ŀ



for j=1:length(SNR_dB)
%����SNR_dB����������ʣ����������ʵݹ��ϵ����     
    SNR_not_dB(j)=10^(SNR_dB(j)/10);         %ת���ɷ�dB��ʽ
    var(j)=1/(2*R*SNR_not_dB(j));                       %�õ���������sigma^2
    eb=exp(-1/(2*var(j)));
    Z=get_awgn_Pb(N,var(j));                   %�ŵ���Bhattacharyya��������
    uc(1:N)=0;
    %�ŵ���ѡ��
    %����Bhattacharyya��������ѡ��
    [Zw,index]=sort(Z,'descend');       %���ս������о���Z
    free_index=index(N-K+1:N);          %��Ϣ���ص�λ��
    frozen_index=index(1:N-K);          %frozenbit��λ��
    [free_index,~]=sort(free_index,'ascend');%�ֶ�crc��polar�뼶��ʱ����Ϣ����λ����Ҫ����һ�µ���
    uc(frozen_index)=b;              
    frame_error=0;
    bit_err_num=zeros(1,FRAMES);
    bit_err_pos=zeros(FRAMES,k);
    %%%%%%%%%�ֲ�߽�ļ���%%%%%%%%%
    crc_bound=crc_bound_cal(free_index,K_layer,layer);
    for frame=1:FRAMES


        %��Ϣ������
        %uΪ��Ϣ����
        rng('shuffle')
        u=randsrc(1,k,[0 1]);
        %����CRCУ����
        for kk=1:layer
            u_crc_layer(1+(kk-1)*K_layer:kk*K_layer)=crc_gen(u(1+(kk-1)*k_layer:kk*k_layer),G,K_layer);
        end




        %��Ϣ�ı���
        uc(free_index)=u_crc_layer;
        %����õ�������Ϊx
        x=encoder(uc);

        %AWGN�ŵ�
        y=awgn_noise(x,var(j));
        %����
        %u_hat_crc=decoder_list_crc_layer_ver1(y,free_index,frozen_index,b,var(j),L,G,layer,crc_bound);
        u_hat_crc=decoder_list_crc_layer(y,free_index,frozen_index,b,var(j),L,G,layer,crc_bound);
        for jj=1:layer
            u_hat(1+(jj-1)*k_layer:jj*k_layer)=u_hat_crc(free_index(1+(jj-1)*K_layer:jj*K_layer-crc_length_layer));
        end

        %��֡�ʣ�ֱ��ͳ����֡���ˣ���ͳ�������ʣ�
        if isempty(u_hat_crc)==1
            frame_error=frame_error+1;
        else
            [bit_err_num(frame),~,bit_err_pos(frame,:)]=biterr(u,u_hat);
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
    FER(j)=frame_error/frame
    %dlmwrite('SC_1024_CRC_24.txt',FER(j),'-append');
end

%semilogy(SNR_dB,FER,'-*b')