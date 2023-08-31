class SizeBin:
    def __init__(self, height, width, thickness, count):
        self.height = height
        self.width = width
        self.thickness = thickness
        self.count = count
    
    def _to_row(self):
        row = []
        row.append(self.height)
        row.append(self.width)
        row.append(self.thickness)
        #row.append(self.count)
        return row
    
    def __str__(self):
        representation = (f"(Height={self.height}, Width={self.width}: "
                          f"Thickness={self.thickness}, Count={self.count}")
        return representation
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...