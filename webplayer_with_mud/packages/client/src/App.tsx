import {useMUD} from "./MUDContext";

const styleUnset = {all: "unset"} as const;

export const App = () => {
    const {
        network: {tables, useStore},
        systemCalls: {addTask, toggleTask, deleteTask},
    } = useMUD();

    const tasks = useStore((state) => {
        const records = Object.values(state.getRecords(tables.Tasks));
        records.sort((a, b) => Number(a.value.createdAt - b.value.createdAt));
        return records;
    });

    useEffect(() => {
        // 在组件挂载完成后执行的代码
        // 类似于 document.ready

        // 在这里可以进行需要在组件挂载完成后执行的逻辑
        alert(123)
        return () => {
            // 在组件卸载时执行的清理操作
            // 类似于 componentWillUnmount

            // 在这里可以进行需要在组件卸载时执行的清理逻辑
        };
    }, []); // 空数组作为第二个参数表示只在组件挂载和卸载时执行一次


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
        </>
    )
        ;
};
