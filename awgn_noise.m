function y=awgn_noise(x,var)
%����������awgn�ŵ�,x��ʾ����,var��ʾ�ŵ�����������,yΪ�ŵ����
N=length(x);
rng('shuffle')
z=sqrt(var)*randn(1,N);
y=2*x-1+z;
end