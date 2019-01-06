function snake(x,y,fps)
%% figure & axes
  L = 20;                             %場地大小
  axis equal                          %坐標軸等長
  axis(0.5+[0 L 0 L])                 %坐標軸邊界
  hold on                             %固定坐標軸
  %% snake
  sz = 300;                           %蛇頭大小
  pos = [x y];                        %蛇頭位置
  dir = [1 0];                        %蛇頭方向
  body = [];                          %蛇身位置矩陣
  long = 5;                           %蛇身長度
  hs = scatter(gca,pos(1),pos(2),sz,'bs','filled');%繪製蛇頭
  %{
  L = 20;                             %遊戲邊界長
  axis equal                          %固定坐標軸
  axis(0.5+[0 L 0 L])                 %設定坐標軸
  hold on                             %固定繪圖座標
  %}
  food_pos = pos + [5,5];                  %食物初始位置
  ha = scatter(gca,food_pos(1),food_pos(2),sz,'rs','filled');   %食物圖物件                 
 
  set(gcf,'KeyPressFcn',@kpfcn)        %設定figure的控制屬性(Control Properties)
 
  %fps = 1;                                     %畫面更新率(frame per sencond)
  game = timer('ExecutionMode','FixedRate','Period',1/fps,'TimerFcn',@gamefcn);   %遊戲畫面更新計時器
  start(game)                                  %計時器開始
 
  function gamefcn(~,~)                    %遊戲畫面定時更新函式
    pos = pos + dir;                       %自動前進
 
    pos(pos > L) = pos(pos > L) - L;       %週期性邊界
    pos(pos < 1) = pos(pos < 1) + L;       %移除蛇尾
      body(end,:) = [];
    end                                   
 
    if intersect(body(2:end,:),pos,'rows') %當蛇身位置包含蛇頭位置
      stop(game)                           %遊戲結束停止計時器
    end                                   
 
    if isequal(pos(1,:),food_pos)              %吃到食物
      long = long + 1;                     %蛇身長度+1
      food_pos = randi(L,[1 2]);               %隨機位置產生新食物
    end                                   
 
    set(ha,'XData',food_pos(1),...             %更新食物圖物件
      'YData',food_pos(2))
    set(hs,'XData',body(:,1),...           %更新蛇圖物件
      'YData',body(:,2));
  end
 
  function kpfcn(~,event)        %KeyPressFcn的回應函式(Callback Function)
    switch event.Key             %依據方向鍵改變方向
      case 'uparrow'
        dirtmp = [0 1];
      case 'downarrow'
        dirtmp = [0 -1];
      case 'leftarrow'
        dirtmp = [-1 0];
      case 'rightarrow'
        dirtmp = [1 0];
      otherwise
        dirtmp = nan;
    end
    if any(dir + dirtmp)         %不可逆向
      dir = dirtmp;
    end
  end
end