function bound=crc_bound_cal(free_index,K_layer,layer)
%%%%%%%crc�ֲ�߽���㺯��%%%%%%%%%%
%free_indexΪ��Ϣλ�������ֲ㼫����ÿ��ĳ��ȣ�layerΪ����
bound=zeros(1,layer+1);
bound(1)=free_index(1);
for i=1:layer
    bound(i+1)=free_index(K_layer*i);
end
