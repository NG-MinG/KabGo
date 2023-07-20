import { Routes, Route } from "react-router-dom";
import BaseLayout from "@layouts/BaseLayout";

const AppRoutes: React.FC = () => {
    return (
        <Routes>
            <Route element={<BaseLayout />}>
                <Route path="/" element={<p>HELLO WORLD</p>} />
            </Route>
        </Routes>
    );
};

export default AppRoutes;
