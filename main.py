from lxml import html
from imageai.Prediction import ImagePrediction
import os
from tkinter.scrolledtext import ScrolledText
import requests
from tkinter import *
from tkinter import filedialog
import shutil


def handle_request():
    execution_path = os.getcwd()
    prediction = ImagePrediction()
    prediction.setModelTypeAsSqueezeNet()
    prediction.setModelPath(os.path.join(execution_path, "squeezenet_weights_tf_dim_ordering_tf_kernels.h5"))
    prediction.loadModel()
    predictions, probabilities = prediction.predictImage(os.path.join(execution_path, "image.jpg"), result_count=2)
    final_hashtag = []

    url = "https://all-hashtag.com/library/contents/ajax_generator.php"
    for i in range(len(predictions)):
        dictionary = {

            'keyword': predictions[i],
            'filter': 'top'
        }

        response = requests.post(url, data=dictionary)
        print(response.status_code)
        tree = html.fromstring(response.content)
        hashtag = tree.xpath('//*[@id="copy-hashtags"]/text()')

        hashtag = list(hashtag[0].split())
        hashtag = hashtag[:10]
        for element in hashtag:
            final_hashtag.append(element)

    response = ",".join(final_hashtag)
    txt.insert(INSERT, response)


def browse():
    filename = filedialog.askopenfile(mode='rb', title='Choose a file').name
    shutil.copy(filename, 'D:/Python data/HashiGen/image.jpg')


# gui part
root = Tk()
root.geometry('400x400')
root.resizable(0, 0)
root.title("Hashigen")
frame1 = Frame(root).pack(expand=True, fill="both")
frame2 = Frame(root).pack(expand=True, fill="both")
txt = ScrolledText(frame1, width=50, height=20)
txt.pack(fill="y")
button = Button(frame2, text="Print hastags", font="Dina 22", bd=0, command=handle_request, relief=GROOVE,
                activebackground="PeachPuff3",
                bg="PeachPuff2").pack(side=LEFT, expand=True, fill="both")
browse_button = Button(frame2, text="Browse", command=browse).pack()
root.mainloop()