class User(object):
    def __init__(self, name, copies, primaryCreates, copyCreates, updates):
        self.name = name
        self.copies = copies
        self.primaryCreates = primaryCreates
        self.copyCreates = copyCreates
        self.updates = updates
    def getTotalSaves(self):
        return self.copies + self.primaryCreates + self.copyCreates + self.updates
