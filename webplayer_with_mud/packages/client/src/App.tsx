import {useMUD} from "./MUDContext";

const styleUnset = {all: "unset"} as const;
import React, {useEffect} from 'react';

export const App = () => {
    const {
        network: {tables, useStore},
        systemCalls: {addTask, toggleTask, deleteTask, addUser, getCard, getCard2},
    } = useMUD();

    const tasks = useStore((state) => {
        const records = Object.values(state.getRecords(tables.Tasks));
        records.sort((a, b) => Number(a.value.createdAt - b.value.createdAt));
        return records;
    });

    const cards = useStore((state) => {
        const records = Object.values(state.getRecords(tables.Cards));
        records.sort((a, b) => Number(a.value.createdAt - b.value.createdAt));
        return records;
    });


    function unityShowBanner(msg, type) {
        // function updateBannerVisibility() {
        //     warningBanner.style.display = warningBanner.children.length ? 'block' : 'none';
        // }
        // // var div = document.createElement('div');
        // // div.innerHTML = msg;
        // // warningBanner.appendChild(div);
        // // if (type == 'error') div.style = 'background: red; padding: 10px;';
        // else {
        //     // if (type == 'warning') div.style = 'background: yellow; padding: 10px;';
        //     setTimeout(function() {
        //         warningBanner.removeChild(div);
        //         updateBannerVisibility();
        //     }, 5000);
        // }
        // updateBannerVisibility();
    }

    let initUnity = () => {
        var container = document.querySelector("#unity-container");
        var canvas = document.querySelector("#unity-canvas");
        var loadingBar = document.querySelector("#unity-loading-bar");
        var progressBarFull = document.querySelector("#unity-progress-bar-full");
        var fullscreenButton = document.querySelector("#unity-fullscreen-button");
        var warningBanner = document.querySelector("#unity-warning");


        var buildUrl = "Build";
        var loaderUrl = buildUrl + "/hex256_build.loader.js";
        var config = {
            dataUrl: buildUrl + "/hex256_build.data",
            frameworkUrl: buildUrl + "/hex256_build.framework.js",
            codeUrl: buildUrl + "/hex256_build.wasm",
            streamingAssetsUrl: "StreamingAssets",
            companyName: "DefaultCompany",
            productName: "My project",
            productVersion: "1.09",
            showBanner: unityShowBanner,
        };


        if (/iPhone|iPad|iPod|Android/i.test(navigator.userAgent)) {
            // Mobile device style: fill the whole browser client area with the game canvas:

            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, height=device-height, initial-scale=1.0, user-scalable=no, shrink-to-fit=yes';
            document.getElementsByTagName('head')[0].appendChild(meta);
            container.className = "unity-mobile";
            canvas.className = "unity-mobile";

            // To lower canvas resolution on mobile devices to gain some
            // performance, uncomment the following line:
            // config.devicePixelRatio = 1;

            // unityShowBanner('WebGL builds are not supported on mobile devices.');
        } else {
            // Desktop style: Render the game canvas in a window that can be maximized to fullscreen:

            canvas.style.width = "100vw";
            canvas.style.height = "100vh";
        }


        var script = document.createElement("script");
        script.src = loaderUrl;
        script.onload = () => {
            createUnityInstance(canvas, config, (progress) => {
                progressBarFull.style.width = 100 * progress + "%";
            }).then((unityInstance) => {
                loadingBar.style.display = "none";
                // fullscreenButton.onclick = () => {
                //     unityInstance.SetFullscreen(1);
                // };
            }).catch((message) => {
                alert(message);
            });
        };
        document.body.appendChild(script);
    }

    useEffect(() => {
        window.addTask = addTask;
        window.addUser = addUser;
        window.getCard = getCard;
        window.getCard2 = getCard2;
        window.cards = cards;
        window.tasks = tasks;

        initUnity();

        return () => {
        };
    }, []);


    return (
        <>
            <div id="unity-container" class="unity-desktop">
                <canvas id="unity-canvas">
                </canvas>
                <div id="unity-loading-bar">
                    <div id="unity-logo"></div>
                    <div id="unity-progress-bar-empty">
                        <div id="unity-progress-bar-full"></div>
                    </div>
                </div>
                {/*<div id="unity-warning"></div>*/}
                {/*<div id="unity-footer">*/}
                {/*    <div id="unity-webgl-logo"></div>*/}
                {/*    <div id="unity-fullscreen-button"></div>*/}
                {/*    <div id="unity-build-title">My project</div>*/}
                {/*</div>*/}
            </div>

            <div class="mud_devtool">
                <div id="card">
                    {cards.map((card) => (
                        <div key={card.tid}>
                            {card.value.tid}
                        </div>
                    ))}
                </div>

                <table>
                    <tbody>
                    {tasks.map((task) => (
                        <tr key={task.id}>
                            <td align="right">
                                <input
                                    type="checkbox"
                                    checked={task.value.completedAt > 0n}
                                    title={task.value.completedAt === 0n ? "Mark task as completed" : "Mark task as incomplete"}
                                    onChange={async (event) => {
                                        event.preventDefault();
                                        const checkbox = event.currentTarget;

                                        checkbox.disabled = true;
                                        try {
                                            await toggleTask(task.key.key);
                                        } finally {
                                            checkbox.disabled = false;
                                        }
                                    }}
                                />
                            </td>
                            <td>{task.value.completedAt > 0n ?
                                <s>{task.value.description}</s> : <>{task.value.description}</>}</td>
                            <td align="right">
                                <button
                                    type="button"
                                    title="Delete task"
                                    style={styleUnset}
                                    onClick={async (event) => {
                                        event.preventDefault();
                                        if (!window.confirm("Are you sure you want to delete this task?")) return;

                                        const button = event.currentTarget;
                                        button.disabled = true;
                                        try {
                                            await deleteTask(task.key.key);
                                        } finally {
                                            button.disabled = false;
                                        }
                                    }}
                                >
                                    &times;
                                </button>
                            </td>
                        </tr>
                    ))}
                    </tbody>
                    <tfoot>
                    <tr>
                        <td>
                            <input type="checkbox" disabled/>
                        </td>
                        <td colSpan={2}>
                            <form
                                onSubmit={async (event) => {
                                    event.preventDefault();
                                    const form = event.currentTarget;
                                    const fieldset = form.querySelector("fieldset");
                                    if (!(fieldset instanceof HTMLFieldSetElement)) return;

                                    const formData = new FormData(form);
                                    const desc = formData.get("description");
                                    if (typeof desc !== "string") return;

                                    fieldset.disabled = true;
                                    try {
                                        await addTask(desc);
                                        form.reset();
                                    } finally {
                                        fieldset.disabled = false;
                                    }
                                }}
                            >
                                <fieldset style={styleUnset}>
                                    <input type="text" name="description"/>{" "}
                                    <button type="submit" title="Add task">
                                        Add
                                    </button>
                                </fieldset>
                            </form>
                        </td>
                    </tr>
                    </tfoot>
                </table>
            </div>


        </>
    )
        ;
};
