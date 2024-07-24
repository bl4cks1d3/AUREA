import React from "react";
import Icon from "@/components/ui/Icon";

const statistics = [
  {
    title: "ARTs Emitidas",
    count: "15",
    bg: "bg-info-500",
    text: "text-info-500",
    percent: "33.3% ",
    icon: "heroicons-outline:menu-alt-1",
  },
  {
    title: "Atividades em andamento",
    count: "2",
    bg: "bg-warning-500",
    text: "text-warning-500",
    percent: "33.3%",
    icon: "heroicons-outline:chart-pie",
  },
  {
    title: "Aguardando aprovação",
    count: "2",
    bg: "bg-primary-500",
    text: "text-primary-500",
    percent: "33.3%  ",
    icon: "heroicons-outline:clock",
  }

];
const GroupChart4 = () => {
  return (
    <>
      {statistics.map((item, i) => (
        <div
          key={i}
          className={`${item.bg} rounded-md p-4 bg-opacity-[0.15] dark:bg-opacity-50 text-center`}
        >
          <div
            className={`${item.text} mx-auto h-10 w-10 flex flex-col items-center justify-center rounded-full bg-white text-2xl mb-4 `}
          >
            <Icon icon={item.icon} />
          </div>
          <span className="block text-sm text-slate-600 font-medium dark:text-white mb-1">
            {item.title}
          </span>
          <span className="block mb- text-2xl text-slate-900 dark:text-white font-medium">
            {item.count}
          </span>
        </div>
      ))}
    </>
  );
};

export default GroupChart4;
