def question(question):
    answer = input(question)
    if answer == 'y':
        return True
    return False


def form(quest1, quest2, quest3, quest4, sub1, sub2, sub3, sub4):
    chosen1 = question(quest1)
    if chosen1 is True:
        print(f"Go to {sub1}")
        return

    chosen2 = question(quest2)
    if chosen2 is True:
        print(f"Go to {sub2}")
        return

    chosen3 = question(quest3)
    if chosen3 is True:
        print(f"Go to {sub3}")
        return

    print(f"Go to {sub4}")
    return


q1 = "Are you an AI enthusiast ? (y/n)"
q2 = "Do you like games ? (y/n)"
q3 = "Would you like to create mobile apps ? (y/n)"
q4 = "Are you a math-guy ? (y/n)"

s1 = "PBR"
s2 = "GD"
s3 = "TPPM"
s4 = "ACTN"

print(f"Optionale: {s1} , {s2} , {s3} , {s4}")

form(q1, q2, q3, q4, s1, s2, s3, s4)

print("---------------------------------------------")

q1 = "Do you like to design  (y/n)?"
q2 = "Do you like psychology ? (y/n)"
q3 = "Do you like social media ? (y/n)"
q4 = "Would you like to work in a field involving Cloud Computing ? (y/n)"

s1 = "HCI"
s2 = "PCPIT"
s3 = "ARMS"
s4 = "CC"

print(f"Optionale: {s1} , {s2} , {s3} , {s4}")

form(q1, q2, q3, q4, s1, s2, s3, s4)

print("---------------------------------------------")

q1 = "Do you like LFAC ? (y/n)"
q2 = "Do you like Java and bank system ? (y/n)"
q3 = "Do you digital systems ? (y/n)"
q4 = "Do you want to work at Continental ? (y/n)"

s1 = "RPA"
s2 = "SCA"
s3 = "MDS"
s4 = "ISSA"

print(f"Optionale: {s1} , {s2} , {s3} , {s4}")

form(q1, q2, q3, q4, s1, s2, s3, s4)
