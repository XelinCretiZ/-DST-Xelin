GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

local yousoul = require("widgets/yousoul")

local function AddYouSoul(self) 
  if self.owner and self.owner:HasTag("xelin") then
      self.yousoul = self:AddChild(yousoul(self.owner))   
    
      self.owner:DoTaskInTime(0.5, function()
      local x1 ,y1, z1 = self.stomach:GetPosition():Get()
      local x2 ,y2, z2 = self.brain:GetPosition():Get()   
      local x3 ,y3, z3 = self.heart:GetPosition():Get()   
      if y2 == y1 or  y2 == y3 then
          print("生成1")
          self.yousoul:SetPosition(self.stomach:GetPosition() + Vector3(x1-x2, 0, 0))
          self.boatmeter:SetPosition(self.moisturemeter:GetPosition() + Vector3(x1-x2, 0, 0))
      else
          print("生成2")
          self.yousoul:SetPosition(self.stomach:GetPosition() + Vector3(x1-x3, 0, 0))
      end

      local s1 = self.stomach:GetScale().x
      local s2 = self.boatmeter:GetScale().x    
      local s3 = self.yousoul:GetScale().x  
  
      if s1 ~= s2 then
            self.boatmeter:SetScale(s1/s2,s1/s2,s1/s2)  --修改船的耐久值大小
      end

      if s1 ~= s3 then
            self.yousoul:SetScale(s1/s3,s1/s3,s1/s3)--避免wg的显示mod有问题修正一下大小
      end
    end)
   end
end

AddClassPostConstruct("widgets/statusdisplays", AddYouSoul)
