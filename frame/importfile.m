function [VarName1,VarName2,VarName3,VarName4] = importfile(filename, startRow, endRow)
%IMPORTFILE1 ���ı��ļ��е���ֵ������Ϊ��ʸ�����롣
%   [VARNAME1,VARNAME2,VARNAME3,VARNAME4] = IMPORTFILE1(FILENAME) ��ȡ�ı��ļ�
%   FILENAME ��Ĭ��ѡ����Χ�����ݡ�
%
%   [VARNAME1,VARNAME2,VARNAME3,VARNAME4] = IMPORTFILE1(FILENAME, STARTROW,
%   ENDROW) ��ȡ�ı��ļ� FILENAME �� STARTROW �е� ENDROW ���е����ݡ�
%
% Example:
%   [VarName1,VarName2,VarName3,VarName4] = importfile1('G9PQ0282.txt',1,
%   2678);
%
%    ������� TEXTSCAN��

% �� MATLAB �Զ������� 2015/01/12 17:06:53

%% ��ʼ��������
delimiter = ' ';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% ÿ���ı��еĸ�ʽ�ַ���:
%   ��1: ˫����ֵ (%f)
%	��2: ˫����ֵ (%f)
%   ��3: ˫����ֵ (%f)
%	��4: ˫����ֵ (%f)
% �й���ϸ��Ϣ������� TEXTSCAN �ĵ���
formatSpec = '%f%f%f%f%[^\n\r]';

%% ���ı��ļ���
fileID = fopen(filename,'r');

%% ���ݸ�ʽ�ַ�����ȡ�����С�
% �õ��û������ɴ˴������õ��ļ��Ľṹ����������ļ����ִ����볢��ͨ�����빤���������ɴ��롣
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% �ر��ı��ļ���
fclose(fileID);

%% ���޷���������ݽ��еĺ���
% �ڵ��������δӦ���޷���������ݵĹ�����˲�����������롣Ҫ�����������޷���������ݵĴ��룬�����ļ���ѡ���޷������Ԫ����Ȼ���������ɽű���

%% ����������������б�������
VarName1 = dataArray{:, 1};
VarName2 = dataArray{:, 2};
VarName3 = dataArray{:, 3};
VarName4 = dataArray{:, 4};


