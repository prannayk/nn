local Narrow, parent = torch.class('nn.Narrow', 'nn.Module')

function Narrow:__init(dimension,offset,length)
   parent.__init(self)
   self.dimension=dimension
   self.index=offset
   self.length=length or 1
   if not dimension or not offset then
      error('nn.Narrow(dimension, offset, length)')
   end
end

function Narrow:updateOutput(input)
   local dim = self.dimension < 0 and input:dim() + self.dimension + 1 or self.dimension
   local length = self.length
   local index = self.index

   if index < 0 then
      index = input:size(dim) + self.index + 1
   end

   if length < 0 then
      length = input:size(dim) - index + 1 - torch.abs(length)
   end

   local output=input:narrow(dim, index, length)
   self.output = self.output:typeAs(output)
   self.output:resizeAs(output):copy(output)
   return self.output
end

function Narrow:updateGradInput(input, gradOutput)
   local dim = self.dimension < 0 and input:dim() + self.dimension + 1 or self.dimension
   local length = self.length
   local index = self.index

   if index < 0 then
      index = input:size(dim) + self.index + 1
   end

   if length < 0 then
      length = input:size(dim) - index + 1 - torch.abs(length)
   end

   self.gradInput = self.gradInput:typeAs(input)
   self.gradInput:resizeAs(input):zero()
   self.gradInput:narrow(dim,index,length):copy(gradOutput)
   return self.gradInput
end
