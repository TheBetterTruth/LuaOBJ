require("LuaOBJ")

object:inherit("person", {
    Name = "Unnamed",
    Age = 0
}, function(self, name, age)
    self.Name = name
    self.Age = age
end)

person.getName = function(self)
    return self.Name
end

person.getAge = function(self)
    return self.Age
end

person:inherit("student", {
    Grade = "Unknown"
}, function(self, name, age, grade)
    self.base(name, age)
    self.Grade = grade
end)
student.getGrade = function(self)
    return self.Grade
end

person.makeStudent = function(self)
    return student:new(self.Name, self.Age, 1)
end
student.gradeUp = function(self)
    self.Grade = self.Grade + 1
end

local john = person:new("John", 14)
print("This is ".. john.getName())
print("He is "..john.getAge().. " years old")
print("Now he's becoming a student")
john = john.makeStudent()

print("He begins in grade ".. john.getGrade())
print("And he's grading up...")
john.gradeUp()
print("Now he's in grade "..john.getGrade())
